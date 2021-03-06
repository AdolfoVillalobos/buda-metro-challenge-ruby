require 'spec_helper'

RSpec.describe Metro::EdgeCostMap do

  let(:train_color) { :NO }
  let(:stations) do
    [
      { name: 'A', neighbors: ['B'], color: :NO },
      { name: 'B', neighbors: %w[A C], color: :GREEN },
      { name: 'C', neighbors: %w[B D G], color: :RED },
      { name: 'D', neighbors: %w[C E], color: :NO }
    ]
  end

  let(:graph) { Metro::MetroNetwork.build(*stations) }
  let(:edge_cost_map) { described_class.build(graph, train_color) }

  describe '#build' do
    before do
      described_class.build(graph, train_color)
    end
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
      it 'edge costs are 1' do
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end

    context 'when train is green' do
      let(:train_color) { :GREEN }
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
      it 'cost to unsupported stations is 0' do
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end

    context 'when train is red' do
      let(:train_color) { :RED }
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
      it 'cost to unsupported stations is 0' do
        expect(edge_cost_map.cost_dict).to eq(output_cost_map)
      end
    end
  end

  describe '#add_edge_cost' do
    let(:cost) { 0 }
    it 'adds edge cost' do
      edge_cost_map.add_edge_cost('A', 'B', cost)
      expect(edge_cost_map.cost_dict[%w[A B]]).to eq(cost)
    end
  end

  describe '#get_edge_cost' do
    before do
      edge_cost_map.add_edge_cost('A', 'B', 5)
    end
    context 'when edge exists' do
      it { expect(edge_cost_map.get_edge_cost('A', 'B')).to eq(5) }
    end

    context 'when edge does not exists' do
      it { expect(edge_cost_map.get_edge_cost('A', 'C')).to eq(nil) }
    end
  end
end
