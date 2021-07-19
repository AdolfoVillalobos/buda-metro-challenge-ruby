# frozen_string_literal: true

require 'utils/command_line_parser'
require 'utils/metro_network_parser'
require 'metro/shortest_path'
require 'metro/metro_network'

class Main
  def self.run(args)
    self.display_args(args)
    data = Metro::MetroNetworkParser.parse(args[:network_file])
    metro = Metro::MetroNetwork.build(*data)
    shortest_path_finder = Metro::MetroShortestPath.new(metro)
    path = shortest_path_finder.shortest_path(args[:source], args[:target],
                                              args[:train_color])

    if path.empty?
      puts "No routes fround from #{args[:source]} to #{args[:target]}"
    else
      puts "Best Route:\n\t #{path.join(' -> ')} "
    end
  end

  def self.display_args(args)
    puts "Parameters:"
    puts "\tFILE: #{args[:network_file]}"
    puts "\tSOURCE: #{args[:source]}"
    puts "\tTARGET: #{args[:target]}"
    puts "\tTRAIN COLOR: #{args[:train_color]}"
    puts "---"
  end
end

if $PROGRAM_NAME == __FILE__

  args = Metro::CommandLineParser.parse(ARGV)
  Main.run(args)
end
