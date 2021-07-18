require 'spec_helper'

RSpec.describe Metro::MetroNetwork do
  let(:metro) { described_class.new }
  let(:station) { { name: 'A', neighbors: %w[B C], color: 1 } }

  describe '#add_station' do
    it 'adds station' do
      metro.add_station(station[:name])
      expect(metro.stations_adjacency).to have_key('A')
    end
  end

  describe '#add_station_color' do
    it 'adds station color' do
      metro.add_station_color(station[:name], station[:color])
      expect(metro.stations_color).to have_key('A')
      expect(metro.stations_color['A']).to eq(1)
    end
  end

  describe '#add_edge' do
    it 'adds edge' do
      metro.add_edge('A', 'B')
      expect(metro.stations_adjacency['A']).to include('B')
    end
  end

  describe '#build' do
    let(:stations) do
      [
        { name: 'A', neighbors: %w[B C], color: 1 },
        { name: 'B', neighbors: ['C'], color: 2 },
        { name: 'C', neighbors: ['A'], color: 0 }
      ]
    end
    let(:metro) { described_class.build(*stations) }
    it 'builds the stations of the MetroNetwork' do
      expect(metro.stations_adjacency).to include('A', 'B', 'C')
      expect(metro.stations_color).to include('A', 'B', 'C')
      expect(metro.stations_color['A']).to eq(1)
      expect(metro.stations_color['B']).to eq(2)
      expect(metro.stations_color['C']).to eq(0)
    end

    it 'builds the edges of the MetroNetwork' do
      expect(metro.stations_adjacency['A']).to include('B', 'C')
      expect(metro.stations_adjacency['B']).to include('C')
      expect(metro.stations_adjacency['C']).to include('A')
    end
  end
end
