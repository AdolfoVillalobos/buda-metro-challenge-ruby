require 'spec_helper'

RSpec.describe Metro::EdgeCostMap do
  def perform
    described_class
      .build(adjacencies, colors, train_color)
      .cost_dict
  end
  let(:train_color) { 0 }
  let(:adjacencies) do
    {
      'A' => Set['B'],
      'B' => Set['A', 'C'],
      'C' => Set['B', 'D', 'G'],
      'G' => Set['C', 'H'],
      'H' => Set['G', 'I'],
      'I' => Set['F', 'H']
    }
  end
  let (:colors) do
    {
      'A' => 0,
      'B' => 0,
      'C' => 0,
      'D' => 0,
      'G' => 1,
      'H' => 2,
      'I' => 1,
      'F' => 0
    }
  end

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
          ['G', 'C'] => 1,
          ['G', 'H'] => 1,
          ['H', 'G'] => 1,
          ['H', 'I'] => 1,
          ['I', 'H'] => 1,
          ['I', 'F'] => 1,
        }
      end
      it 'creates correct costs for edges' do
        expect(perform).to eq(output_cost_map)
      end
    end

    context 'when train is green' do
      let(:train_color) { 1 }
      let(:output_cost_map) do
        {
          ['A', 'B'] => 1,
          ['B', 'A'] => 1,
          ['B', 'C'] => 1,
          ['C', 'B'] => 1,
          ['C', 'D'] => 1,
          ['C', 'G'] => 1,
          ['G', 'C'] => 1,
          ['G', 'H'] => 0,
          ['H', 'G'] => 1,
          ['H', 'I'] => 1,
          ['I', 'H'] => 0,
          ['I', 'F'] => 1,
        }
      end
      it 'creates correct costs for edges' do
        expect(perform).to eq(output_cost_map)
      end 
    end

    context 'when train is red' do
      let(:train_color) { 2 }
      let(:output_cost_map) do
        {
          ['A', 'B'] => 1,
          ['B', 'A'] => 1,
          ['B', 'C'] => 1,
          ['C', 'B'] => 1,
          ['C', 'D'] => 1,
          ['C', 'G'] => 0,
          ['G', 'C'] => 1,
          ['G', 'H'] => 1,
          ['H', 'G'] => 0,
          ['H', 'I'] => 0,
          ['I', 'H'] => 1,
          ['I', 'F'] => 1,
        }
      end
      it 'creates correct costs for edges' do
        expect(perform).to eq(output_cost_map)
      end 
    end
  end
end
