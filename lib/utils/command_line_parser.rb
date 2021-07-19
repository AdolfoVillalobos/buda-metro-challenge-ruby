# command_line_parser.rb

require 'optparse'

module Metro
  # The Metro::CommandLineParser class implements an
  # utility to:
  # - Parse the command line arguments given by the user
  # - Handle missing arguments.
  class CommandLineParser
    TRAIN_COLORS = { 'green' => :GREEN, 'red' => :RED, 'no' => :NO }.freeze

    # Parses the options given by the command line argument
    # - FILE, SOURCE and TARGET are required arguments.
    # - TRAINCOLOR is optional (default to :NO).
    def self.parse(options)
      args = { train_color: :NO }

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: bundle exec ruby -Ilib script/main.rb '\
                        '-f FILE -s SOURCE -t TARGET -c TRAINCOLOR'

        opts.on('-f', '--file FILE',
                'FILE (json) containing Metro Network (required)') do |n|
          args[:network_file] = n
        end

        opts.on('-s', '--source SOURCE', 'SOURCE Station (required)') do |n|
          args[:source] = n
        end

        opts.on('-tTARGET', '--target TARGET',
                'TARGET Station (required)') do |n|
          args[:target] = n
        end

        opts.on('-c', '--train-color TRAINCOLOR',
                'Color of the Train: no, red or green (optional)') do |n|
          args[:train_color] = Metro::CommandLineParser::TRAIN_COLORS[n]
          unless Metro::CommandLineParser::TRAIN_COLORS.has_key?(n)
            raise 'TRAIN COLOR not supported'
          end
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
