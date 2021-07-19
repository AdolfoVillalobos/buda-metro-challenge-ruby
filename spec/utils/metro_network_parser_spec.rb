# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Metro::MetroNetworkParser do
  describe '#self.is_valid_schema?' do
    before do
      stub_const('Metro::MetroNetworkParser::JSON_SCHEMA',
                 File.join('lib', 'utils', 'schemas', 'metro_network_schema.json'))
    end

    def is_valid
      described_class.is_valid_schema?(hash)
    end
    context 'when json schema is valid' do
      let(:hash) do
        { 'metroStations' => [
          { 'name' => 'A', "neighbors": %w[C B], 'color' => 0 }
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
            { "neighbors": %w[C B], 'color' => 0 }
          ] }
        end
        it { expect(is_valid).to eq(false) }
      end

      context 'when neighbors are missing' do
        let(:hash) do
          { 'metroStations' => [
            { 'name' => 'A', 'color' => 0 }
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
    end
  end

  describe 'self.parse' do

    def parse
      described_class.parse(filename)
    end

    let(:filename) { 'spec/fixtures/base.json' }

    context 'when valid input file' do
      it { expect(parse).to be_a(Array)}
    end

    context 'when file does not exist' do
      let(:filename) { 'dfgejhgfjh' }
      it { expect{parse}.to raise_error( Errno::ENOENT)}
    end

    context 'when file cannot be parsed as JSON' do
      let(:filename) { 'spec/fixtures/bad_json.json' }
      it { expect{parse}.to raise_error(RuntimeError, 'FILE cannot be parsed as JSON')}
    end

    context 'when file is empty' do
      let(:filename) { 'spec/fixtures/empty_file' }
      it { expect{parse}.to raise_error(RuntimeError, 'FILE cannot be parsed as JSON')}
    end
  end
end
