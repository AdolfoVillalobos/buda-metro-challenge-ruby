require 'spec_helper'

RSpec.describe Metro::MetroShortestPath do
  def mock_shortest_path
    described_class
      .new(graph)
      .shortest_path(source, target, train_color)
  end

  let(:stations) do
    [
      { name: 'A', neighbors: ['B'], color: :NO },
      { name: 'B', neighbors: %w[A C], color: :NO },
      { name: 'C', neighbors: %w[B D G], color: :NO },
      { name: 'D', neighbors: %w[C E], color: :NO },
      { name: 'E', neighbors: %w[D F], color: :NO },
      { name: 'F', neighbors: %w[E I], color: :NO },
      { name: 'G', neighbors: %w[C H], color: :GREEN },
      { name: 'H', neighbors: %w[G I], color: :RED },
      { name: 'I', neighbors: %w[H F], color: :GREEN },
      { name: 'J', neighbors: [], color: :NO }
    ]
  end
  let(:source) { 'A' }
  let(:target) { 'F' }
  let(:train_color) { :NO }
  let(:graph) { Metro::MetroNetwork.build(*stations) }

  describe '#shortest_path' do
    describe 'base network from buda challenge' do
      context 'when train has no color' do
        it { expect(mock_shortest_path).to eq(%w[A B C D E F]) }
      end

      context 'when train is green' do
        let(:train_color) { :GREEN }
        it {
          expect(mock_shortest_path).to eq(%w[A B C D E
                                              F]).or eq(%w[A B C G I F])
        }
      end

      context 'when train is red' do
        let(:train_color) { :RED }
        it { expect(mock_shortest_path).to eq(%w[A B C H F]) }
      end

      context 'when source and target are equal' do
        let(:source) { 'A' }
        let(:target) { 'A' }
        it { expect(mock_shortest_path).to eq(['A']) }
      end

      context 'when train cant stop at target' do
        let(:target) { 'G' }
        let(:train_color) { :RED }
        it { expect(mock_shortest_path).to eq([]) }
      end

      context 'when train cant start from source' do
        let(:source) { 'G' }
        let(:train_color) { :RED }
        it { expect(mock_shortest_path).to eq([]) }
      end

      context 'when target is not reachable' do
        let(:target) { 'J' }
        it do
          expect(mock_shortest_path).to eq([])
        end
      end

      context 'when source is not a station' do
        let(:source) { 'X' }
        it do
          expect do
            mock_shortest_path
          end.to raise_error(RuntimeError,
                             'SOURCE station does not exist')
        end
      end

      context 'when target is not a station' do
        let(:target) { 'X' }
        it {
          expect do
            mock_shortest_path
          end.to raise_error(RuntimeError,
                             'TARGET station does not exist')
        }
      end
    end
  end
end
