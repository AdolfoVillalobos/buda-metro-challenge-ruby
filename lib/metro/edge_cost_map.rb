# edge_cost_map.rb

module Metro
  # The Metro::EdgeCostMap implements a hash that
  # maps an edge of the graph to its cost
  #
  # This allows us to LookUp the cost during the BFS 0-1 algorithm
  class EdgeCostMap
    attr_accessor :cost_dict

    def initialize
      @cost_dict = {}
    end

    # Calculates the cost of an edge depending on the color of the train
    #
    # If the train has no color, then 1
    # If the  train has the same color than the target station, then 1
    # If the target has no color, then 1.
    #
    # In any other case, the train is not allowed to stop at target
    # and thus returns 0

    def edge_cost(colors, target, train_color)
      return 1 if train_color == :NO
      return 1 if train_color == colors[target]
      return 1 if colors[target] == :NO

      0
    end

    # adds a new edge cost
    def add_edge_cost(from, to, cost)
      @cost_dict[[from, to]] = cost
    end

    # gets the cost of an edge (if exists)
    def get_edge_cost(from, to)
      return @cost_dict[[from, to]] if @cost_dict.has_key?([from, to])
    end

    # recalculates all the costs depending on the train color
    def self.build(graph, train_color)
      edge_map = new
      graph.stations_adjacency.each do |station, adj_list|
        adj_list.each do |neighbor|
          cost = edge_map.edge_cost(graph.stations_color, neighbor, train_color)
          edge_map.add_edge_cost(station, neighbor, cost)
        end
      end
      edge_map
    end
  end
end
