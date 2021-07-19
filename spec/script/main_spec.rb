require 'spec_helper'

RSpec.describe Main do
  def run
    described_class.run(args)
  end

  def out(path)
    return "No routes fround from #{args[:source]} to #{args[:target]}" if path.empty?
    return "Best Route:\n\t #{path.join(' -> ')} "
  end

  context 'when route exists' do
    let(:args) do
      {
        train_color: :RED,
        source: 'A',
        target:'F',
        network_file: 'data/base.json'
      }
    end
    it 'returns best route' do
      expect(run).to eq(out(['A', 'B', 'C', 'H', 'F']))
    end
  end

  context 'when route does not exist' do
    context 'when route exists' do
      let(:args) do
        {
          train_color: :RED,
          source: 'B',
          target:'I',
          network_file: 'data/base.json'
        }
      end
      it 'says there are no routes' do
        expect(run).to eq(out([]))
      end
    end
  end
end
