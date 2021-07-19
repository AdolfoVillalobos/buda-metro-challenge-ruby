# metro_network_parser.rb

require 'json'
require 'json-schema'

require 'active_support'
require 'active_support/core_ext'

require 'getoptlong'

module Metro
  # The Metro::MetroNetworkParser class implements an utility to
  # - Validate that the JSON file can be parsed correctly
  # - Validate that the JSON file has the correctr schema for the graph
  # - Parse the JSON file into an Array of stations, represented by a Hash.
  class MetroNetworkParser
    JSON_SCHEMA = File.join('lib', 'utils', 'schemas',
                            'metro_network_schema.json')
    STATION_COLORS = { '' => :NO, 'V' => :GREEN, 'R' => :RED }.freeze

    # Validates the Schema of the JSON object
    def self.valid_schema?(hash)
      JSON::Validator.validate(JSON_SCHEMA, hash)
    end

    # Parses the JSON input file. Fails if schema is not valid
    # or JSON file cant be parsed
    def self.parse(filename)
      path = File.join(File.dirname(__FILE__), '../..', filename)
      file_content = File.open(path).read

      begin
        hash = JSON.parse(file_content)
      rescue JSON::ParserError
        raise 'FILE cannot be parsed as JSON'
      end

      raise 'FILE json schema is not valid' unless valid_schema?(hash)

      hash = hash['metroStations'].map(&:symbolize_keys)
      hash.each { |station| station[:color] = STATION_COLORS[station[:color]] }
    end
  end
end
