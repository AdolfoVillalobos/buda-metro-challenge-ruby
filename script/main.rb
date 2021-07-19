# main.rb 

require 'utils/command_line_parser'
require 'utils/metro_network_parser'
require 'metro/shortest_path'
require 'metro/metro_network'

# The Main class implements the funtionality
# to read and parse the user input through the CLI,
# and perform the necesary steps to obtain the shortest path
#
# The steps are:
# - User inputs the required arguments
# - Metro::CommandLineParser  parses the arguments
# - Metro::MetroNetworkParser parses the JSON file
# - Metro::MetroNetwork  builds the Metro graph
# - Metro::MetroShortestPath finds the path
# - Main outputs the results to the user
class Main
  def self.run(args)
    data = Metro::MetroNetworkParser.parse(args[:network_file])
    metro = Metro::MetroNetwork.build(*data)
    shortest_path_finder = Metro::MetroShortestPath.new(metro)
    path = shortest_path_finder.shortest_path(args[:source], args[:target],
                                              args[:train_color])

    return "No routes fround from #{args[:source]} to #{args[:target]}" if path.empty?
    return "Best Route:\n\t #{path.join(' -> ')} "
  end

  def self.display_args(args)
    puts 'Parameters:'
    puts "\tFILE: #{args[:network_file]}"
    puts "\tSOURCE: #{args[:source]}"
    puts "\tTARGET: #{args[:target]}"
    puts "\tTRAIN COLOR: #{args[:train_color]}"
    puts '---'
  end
end

if $PROGRAM_NAME == __FILE__

  args = Metro::CommandLineParser.parse(ARGV)
  Main.display_args(args)
  out = Main.run(args)
  puts out
end
