require 'spec_helper'

RSpec.describe Metro::EdgeCostMap do

  let(:train_color) { 0 }
  let(:stations) do
    [
      {name: 'A', neighbors: ['B'], color: 0},
      {name: 'B', neighbors: ['A', 'C'], color: 1},
      {name: 'C', neighbors: ['B', 'D', 'G'], color: 2},
      {name: 'D', neighbors: ['C', 'E'], color: 0}
    ]
  end

  let(:graph) { Metro::MetroNetwork.build(*stations) }
  let(:edge_cost_map) { described_class.new(graph) }

  describe '#build' do
    context 'when train has no color' do
      let(:output_cost_map) do
        {
          ['A', 'B'] => 1,
          ['B', 'A'] => 1,
          ['B', 'C'] => 1,
          ['C', 'B'] => 1,
          ['C', 'D'] => 1,
          ['C', 'G'] => 1,
          ['D', 'C'] => 1,
          ['D', 'E'] => 1
        }
      end
      it 'creates correct costs for edges' do
        edge_cost_map.build(train_color)
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end

    context 'when train is green' do
      let(:train_color) { 1 }
      let(:output_cost_map) do
        {
          ['A', 'B'] => 1,
          ['B', 'A'] => 1,
          ['B', 'C'] => 0,
          ['C', 'B'] => 1,
          ['C', 'D'] => 1,
          ['C', 'G'] => 0,
          ['D', 'C'] => 0,
          ['D', 'E'] => 0
        }
      end
      it 'creates correct costs for edges' do
        edge_cost_map.build(train_color)
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end

    context 'when train is red' do
      let(:train_color) { 2 }
      let(:output_cost_map) do
        {
          ['A', 'B'] => 0,
          ['B', 'A'] => 1,
          ['B', 'C'] => 1,
          ['C', 'B'] => 0,
          ['C', 'D'] => 1,
          ['C', 'G'] => 0,
          ['D', 'C'] => 1,
          ['D', 'E'] => 0
        }
      end
      it 'creates correct costs for edges' do
        edge_cost_map.build(train_color)
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end
  end
end
