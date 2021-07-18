require 'set'

module Metro
  class MetroNetwork
    attr_accessor :stations_adjacency, :stations_color

    def self.build(*data)
      graph = new
      data.each do |station|
        graph.add_station(station[:name])
        graph.add_station_color(station[:name], station[:color])
        station[:neighbors].each do |neighbor|
          graph.add_edge(station[:name], neighbor)
        end
      end
      graph
    end

    def initialize
      @stations_adjacency = {}
      @stations_color = {}
    end

    def add_station(v)
      @stations_adjacency[v] ||= Set.new
    end

    def add_station_color(v, color)
      @stations_color[v] ||= color
    end

    def add_edge(source, target)
      add_station(source)
      add_station(target)
      @stations_adjacency[source].add(target)
    end

    def has_station?(v)
      @stations_adjacency.has_key?(v)
    end

    def get_color(v)
      @stations_color[v]
    end

    def each_neighbor(station, &a)
      neighbors = @stations_adjacency[station]
      neighbors.each(&a)
    end
  end
end
