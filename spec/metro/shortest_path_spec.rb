require 'spec_helper'

RSpec.describe Metro::MetroShortestPath do

  def mock_shortest_path
    described_class
      .new(graph)
      .shortest_path(source, target, train_color)
  end

  let(:stations) do
    [
      {name: 'A', neighbors: ['B'], color: 0},
      {name: 'B', neighbors: ['A', 'C'], color: 0},
      {name: 'C', neighbors: ['B', 'D', 'G'], color: 0},
      {name: 'D', neighbors: ['C', 'E'], color: 0},
      {name: 'E', neighbors: ['D', 'F'], color: 0},
      {name: 'F', neighbors: ['E', 'I'], color: 0},
      {name: 'G', neighbors: ['C', 'H'], color: 1},
      {name: 'H', neighbors: ['G', 'I'], color: 2},
      {name: 'I', neighbors: ['H', 'F'], color: 1},
      {name: 'J', neighbors: [], color: 0}
    ]
  end
  let(:source) { 'A' }
  let(:target) { 'F' }
  let(:train_color) { 0 }
  let(:graph) { Metro::MetroNetwork.build(*stations) }

  describe '#shortest_path' do
    describe 'base network from buda challenge' do
      context 'when train has no color' do
        it { expect(mock_shortest_path).to eq(['A', 'B', 'C', 'D', 'E', 'F']) }
      end

      context 'when train is green' do
        let(:train_color) { 1 }
        it { expect(mock_shortest_path).to eq(['A', 'B', 'C', 'D', 'E', 'F']).or eq(['A', 'B', 'C', 'G', 'I', 'F']) }
      end

      context 'when train is red' do
        let(:train_color) { 2 }
        it "" do
          expect(mock_shortest_path).to eq(['A', 'B', 'C', 'H', 'F'])
        end
      end

      context 'when source and target are equal' do
        let(:source) { 'A' }
        let(:target) { 'A' }
        it { expect(mock_shortest_path).to eq(['A']) }
      end

      context 'when train cant stop at target' do
        let(:target) { 'G' }
        let(:train_color) { 2 }
        it "" do
          expect(mock_shortest_path).to eq([])
        end
      end

      context 'when train cant start from source' do
        let(:source) { 'G' }
        let(:train_color) { 2 }
        it "",  :focus => true do
          expect(mock_shortest_path).to eq([])
        end
      end

      context 'when target is not reachable' do
        let(:target) { 'J' }
        it do
          expect(mock_shortest_path).to eq([])
        end
      end
    end
  end
end
