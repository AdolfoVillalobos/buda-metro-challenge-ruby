require 'algorithms'
require 'utils/recover_path'
require 'metro/edge_cost_map'

module Metro
  # The Metro::MetroShortestPath implements the BFS 0-1 algorithm to
  # find the path with the least number of station stops from SOURCE to TARGET
  class MetroShortestPath
    attr_accessor :parents

    INF = 1.0 / 0

    def initialize(graph)
      @graph = graph
      @edge_cost_map = EdgeCostMap.new(graph)
      @distance_map = Hash.new(INF)
      @parents = {}
    end

    # Steps to find the shortets path:
    #   - Raise error is the SOURCE or TARGET are not in the graph
    #   - Setup the necesary data structures
    #   - Setup the Edge Costs, according to the train color
    #   - Perform the BFS 0-1 algorithm.
    #   - Recover the path to target.
    #   - Clear the path from all stations in which train cannot stop
    def shortest_path(source, target, train_color)
      raise 'SOURCE station does not exist' unless @graph.station?(source)
      raise 'TARGET station does not exist' unless @graph.station?(target)
      return [] if train_cant_start(source, train_color)

      setup(source)
      @edge_cost_map.build(train_color)
      bfs(target)
      path = RecoverPath.new(source, @parents).recover_path(target)
      clear_path(path, source, target)
    end

    # Setup of the BFS algorithm
    # - Creates an empty Deque data structure
    # - Pushes the SOURCE to the end
    # - Initializes the distance of the SOURCE to itself at 0
    def setup(source)
      @queue = Containers::Deque.new
      @queue.push_front(source)
      @distance_map[source] = 0
    end

    # Performs the BFS algorithm to iterate through the graph until
    # the TARGET has been reached.
    def bfs(target)
      until @queue.empty?
        current = @queue.pop_front

        break if current == target

        @graph.each_neighbor(current) do |neighbor|
          bfs_visit(current, neighbor)
        end
      end
    end

    # Performs the BFS iteration from a specific node to a neighbor
    # Here we include the BFS 0-1 logic to put high priority to
    # neighbors to which the cost is 0, pushing them to the front.
    def bfs_visit(from, to)
      edge_cost = @edge_cost_map.get_edge_cost(from, to)
      option = @distance_map[from] + edge_cost

      if @distance_map[to] > option
        @distance_map[to] = option
        @parents[to] = from

        if edge_cost == 0
          @queue.push_front(to)
        elsif edge_cost == 1
          @queue.push_back(to)
        end
      end
    end

    # Removes from the path all stations in which the train cannot stop
    def clear_path(path, source, target)
      cleared_path = [source]
      path.each_with_index do |_x, i|
        cleared_path.push(path[i]) if @edge_cost_map.get_edge_cost(path[i - 1],
                                                                   path[i]) == 1
      end
      if cleared_path.include?(source) && cleared_path.include?(target)
        return cleared_path
      end

      []
    end

    # Returns true the station has a color from which a train cannot start
    def train_cant_start(source, train_color)
      @graph.get_color(source) != :NO and \
        train_color != :NO and train_color != @graph.get_color(source)
    end
  end
end
