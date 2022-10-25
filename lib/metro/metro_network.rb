# metro_network.rb

require 'set'

module Metro
  # The Metro::MetroNetwork class implements
  # a directed graph using an adjacency lists data structure.
  #
  # Using adjacency list as the core data structure simplifies
  # the implementation of Breadth First Search (BFS) algorithms we use
  # to find the shortest path
  #
  # Additionally, the graph keeps track of station color, relevant
  # to the BFS 0-1 logic.
  class MetroNetwork
    attr_accessor :stations_adjacency, :stations_color

    # Builds the Adjacency List data structure
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

    # adds station to graph
    def add_station(station)
      @stations_adjacency[station] ||= Set.new
    end

    # adds station color
    def add_station_color(station, color)
      @stations_color[station] ||= color
    end

    # adds edge to graph
    def add_edge(source, target)
      add_station(source)
      add_station(target)
      @stations_adjacency[source].add(target)
    end

    # check if station exists
    def station?(station)
      @stations_adjacency.has_key?(station)
    end

    # gets station color
    def get_color(station)
      @stations_color[station]
    end

    # applies "func" to every neighbor of station
    def each_neighbor(station, &func)
      neighbors = @stations_adjacency[station]
      neighbors.each(&func)
    end
  end
end
