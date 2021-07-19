# frozen_string_literal: true

require 'utils/command_line_parser'
require 'utils/metro_network_parser'
require 'metro/shortest_path'
require 'metro/metro_network'

class Main
  def self.run(args)
    data = Metro::MetroNetworkParser.parse(args[:network_file])
    metro = Metro::MetroNetwork.build(*data)
    shortest_path_finder = Metro::MetroShortestPath.new(metro)
    path = shortest_path_finder.shortest_path(args[:source], args[:target],
                                              args[:train_color])

    puts "No routes from #{@args[:source]} to #{@args[:target]}" if path.empty?
    puts path.join(' -> ')
  end
end

if $PROGRAM_NAME == __FILE__

  args = Metro::CommandLineParser.parse(ARGV)
  Main.run(args)

  puts ARGV
end
