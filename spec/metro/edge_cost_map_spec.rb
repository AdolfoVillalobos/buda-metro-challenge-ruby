require 'spec_helper'

RSpec.describe Metro::EdgeCostMap do
  let(:train_color) { 0 }
  let(:stations) do
    [
      { name: 'A', neighbors: ['B'], color: 0 },
      { name: 'B', neighbors: %w[A C], color: 1 },
      { name: 'C', neighbors: %w[B D G], color: 2 },
      { name: 'D', neighbors: %w[C E], color: 0 }
    ]
  end

  let(:graph) { Metro::MetroNetwork.build(*stations) }
  let(:edge_cost_map) { described_class.new(graph) }

  describe '#build' do
    context 'when train has no color' do
      let(:output_cost_map) do
        {
          %w[A B] => 1,
          %w[B A] => 1,
          %w[B C] => 1,
          %w[C B] => 1,
          %w[C D] => 1,
          %w[C G] => 1,
          %w[D C] => 1,
          %w[D E] => 1
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
          %w[A B] => 1,
          %w[B A] => 1,
          %w[B C] => 0,
          %w[C B] => 1,
          %w[C D] => 1,
          %w[C G] => 0,
          %w[D C] => 0,
          %w[D E] => 0
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
          %w[A B] => 0,
          %w[B A] => 1,
          %w[B C] => 1,
          %w[C B] => 0,
          %w[C D] => 1,
          %w[C G] => 0,
          %w[D C] => 1,
          %w[D E] => 0
        }
      end
      it 'creates correct costs for edges' do
        edge_cost_map.build(train_color)
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end
  end
end
