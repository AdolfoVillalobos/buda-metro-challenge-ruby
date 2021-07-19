# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Metro::MetroNetworkParser do
  describe '#self.valid_schema?' do
    before do
      stub_const('Metro::MetroNetworkParser::JSON_SCHEMA',
                 File.join('lib', 'utils', 'schemas',
                           'metro_network_schema.json'))
    end

    def is_valid
      described_class.valid_schema?(hash)
    end
    context 'when json schema is valid' do
      let(:hash) do
        { 'metroStations' => [
          { 'name' => 'A', "neighbors": %w[C B], 'color' => '' }
        ] }
      end
      it { expect(is_valid).to eq(true) }
    end

    context 'when input schema is invalid' do
      context 'when empty stations' do
        let(:hash) do
          { 'metroStations' => [] }
        end
        it { expect(is_valid).to eq(false) }
      end

      context 'when name is missing' do
        let(:hash) do
          { 'metroStations' => [
            { "neighbors": %w[C B], 'color' => :NO }
          ] }
        end
        it { expect(is_valid).to eq(false) }
      end

      context 'when neighbors are missing' do
        let(:hash) do
          { 'metroStations' => [
            { 'name' => 'A', 'color' => :NO }
          ] }
        end
        it { expect(is_valid).to eq(false) }
      end

      context 'when color is missing' do
        let(:hash) do
          { 'metroStations' => [
            { 'name' => 'A', 'neighbors' => %w[B C] }
          ] }
        end
        it { expect(is_valid).to eq(false) }
      end

      context 'when color is not valid' do
        let(:hash) do
          { 'metroStations' => [
            { 'name' => 'A', 'neighbors' => %w[B C], 'color' => 'other' }
          ] }
        end
        it { expect(is_valid).to eq(false) }
      end
    end
  end

  describe 'self.parse' do
    def parse
      described_class.parse(filename)
    end

    context 'when valid input file' do
      let(:filename) { 'spec/fixtures/base.json' }
      let(:output) do
        [
          { name: 'A', neighbors: ['B'], color: :NO },
          { name: 'B', neighbors: %w[A C], color: :NO },
          { name: 'C', neighbors: %w[B D G], color: :GREEN },
          { name: 'D', neighbors: %w[C E], color: :GREEN },
          { name: 'E', neighbors: %w[D F], color: :NO },
          { name: 'F', neighbors: %w[E I], color: :NO },
          { name: 'G', neighbors: %w[C H], color: :GREEN },
          { name: 'H', neighbors: %w[G I], color: :RED },
          { name: 'I', neighbors: %w[H F], color: :GREEN },
          { name: 'J', neighbors: [], color: :NO }
        ]
      end

      it { expect(parse).to eq(output) }
    end

    context 'when file does not exist' do
      let(:filename) { 'dfgejhgfjh' }
      it { expect { parse }.to raise_error(Errno::ENOENT) }
    end

    context 'when a station has missing color' do
      let(:filename) { 'spec/fixtures/missing_color.json' }
      it {
        expect do
          parse
        end.to raise_error(RuntimeError, 'FILE json schema is not valid')
      }
    end

    context 'when file cannot be parsed as JSON' do
      let(:filename) { 'spec/fixtures/bad_json.json' }
      it {
        expect do
          parse
        end.to raise_error(RuntimeError, 'FILE cannot be parsed as JSON')
      }
    end

    context 'when file is empty' do
      let(:filename) { 'spec/fixtures/empty_file' }
      it {
        expect do
          parse
        end.to raise_error(RuntimeError, 'FILE cannot be parsed as JSON')
      }
    end

    context 'when missing stations' do
      let(:filename) { 'spec/fixtures/missing_stations.json' }
      it {
        expect do
          parse
        end.to raise_error(RuntimeError, 'FILE json schema is not valid')
      }
    end
  end
end
