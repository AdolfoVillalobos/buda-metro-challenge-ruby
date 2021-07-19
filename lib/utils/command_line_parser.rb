# frozen_string_literal: true

require 'optparse'

module Metro
  class CommandLineParser
    TRAIN_COLORS = { 'green' => 1, 'red' => 2, 'no' => 0 }.freeze

    def self.parse(options)
      args = { train_color: 0 }

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: bundle exec ruby -Ilib bin/example.rb [options]'

        opts.on('-f', '--file FILE', 'JSON FILE with Metro Network') do |n|
          args[:network_file] = n
        end

        opts.on('-s', '--source SOURCE', 'SOURCE Station') do |n|
          args[:source] = n
        end

        opts.on('-tTARGET', '--target TARGET', 'TARGET Station') do |n|
          args[:target] = n
        end

        opts.on('-c', '--train-color TRAINCOLOR', 'Train Color (Optional)') do |n|
          args[:train_color] = Metro::CommandLineParser::TRAIN_COLORS[n]
          raise 'TRAIN COLOR not supported' unless Metro::CommandLineParser::TRAIN_COLORS.has_key?(n)
        end

        opts.on('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end
      end

      opt_parser.parse!(options)

      raise 'SOURCE missing' if args[:source].nil?
      raise 'TARGET missing' if args[:target].nil?
      raise 'FILE missing' if args[:network_file].nil?

      args
    end
  end
end
