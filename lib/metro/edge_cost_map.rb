module Metro
  class EdgeCostMap
    attr_accessor :cost_dict

    def initialize
      @cost_dict = {}
    end

    def edge_cost(target, train_color, colors)
      return 1 if train_color == 0
      return 1 if train_color == colors[target]
      return 1 if colors[target] == 0

      0
    end

    def add_edge_cost(a, b, cost)
      @cost_dict[[a, b]] = cost
    end

    def get_edge_cost(a, b)
      return @cost_dict[[a, b]] if @cost_dict.has_key?([a, b])
    end

    def self.build(adjacencies, colors, train_color)
      map = new
      adjacencies.each do |station, adjList|
        adjList.each do |neighbor|
          cost = map.edge_cost(neighbor, train_color, colors)
          map.add_edge_cost(station, neighbor, cost)
        end
      end
      map
    end
  end
end
