module Metro
  class EdgeCostMap
    attr_accessor :cost_dict

    def initialize(graph)
      @cost_dict = {}
      @colors = graph.stations_color
      @adjacencies = graph.stations_adjacency
    end

    def edge_cost(target, train_color)
      return 1 if train_color == 0
      return 1 if train_color == @colors[target]
      return 1 if @colors[target] == 0

      0
    end

    def add_edge_cost(from, to, cost)
      @cost_dict[[from, to]] = cost
    end

    def get_edge_cost(from, to)
      return @cost_dict[[from, to]] if @cost_dict.has_key?([from, to])
    end

    def build(train_color)
      @adjacencies.each do |station, adjList|
        adjList.each do |neighbor|
          cost = edge_cost(neighbor, train_color)
          add_edge_cost(station, neighbor, cost)
        end
      end
    end
  end
end
