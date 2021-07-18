require 'algorithms'
require 'metro/recover_path'
require 'metro/edge_cost_map'

module Metro
  class MetroShortestPath
    attr_accessor :parents

    INF = 1.0 / 0

    def initialize(graph)
      @graph = graph
      @edge_cost_map = EdgeCostMap.new(graph)
      @distance_map = Hash.new(INF)
      @parents = {}
    end

    def shortest_path(source, target, train_color)
      return [] if train_cant_start(source, train_color)
      setup(source)
      @edge_cost_map.build(train_color)
      bfs(target)
      path = RecoverPath.new(source, @parents).recover_path(target)
      clear_path(path, source, target)
    end

    def setup(source)
      @queue = Containers::Deque.new
      @queue.push_front(source)
      @distance_map[source] = 0
    end

    def bfs(target)
      until @queue.empty?
        current = @queue.pop_front

        break if current == target

        @graph.each_neighbor(current) do |neighbor|
          bfs_visit(current, neighbor)
        end
      end
    end

    def bfs_visit(u, v)
      edge_cost = @edge_cost_map.get_edge_cost(u, v)
      option = @distance_map[u] + edge_cost

      if @distance_map[v] > option
        @distance_map[v] = option
        @parents[v] = u

        if edge_cost == 0
          @queue.push_front(v)
        elsif edge_cost == 1
          @queue.push_back(v)
        end
      end
    end

    def clear_path(path, source, target)
      cleared_path = [source]
      path.each_with_index do |x, i|
        cleared_path.push(path[i]) if @edge_cost_map.get_edge_cost(path[i-1], path[i]) == 1
      end
      return cleared_path if cleared_path.include?(source) and cleared_path.include?(target)
      return []
    end

    def train_cant_start(source, train_color)
      @graph.get_color(source) !=0 and train_color !=0 and train_color != @graph.get_color(source)
    end
  end
end