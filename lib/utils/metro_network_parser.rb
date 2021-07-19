# frozen_string_literal: true

require 'json'
require 'json-schema'

require 'active_support'
require 'active_support/core_ext'

require 'getoptlong'

module Metro
  class MetroNetworkParser
    JSON_SCHEMA = File.join('lib', 'utils', 'schemas', 'metro_network_schema.json')
    STATION_COLORS = { "" => :NO, "V" => :GREEN, "R" => :RED }
    def self.is_valid_schema?(hash)
      JSON::Validator.validate(JSON_SCHEMA, hash)
    end

    def self.parse(filename)
      path = File.join(File.dirname(__FILE__), '../..', filename)
      file_content = File.open(path).read

      begin
        hash = JSON.parse(file_content)
      rescue JSON::ParserError
        raise 'FILE cannot be parsed as JSON'
      end

      raise 'FILE json schema is not valid' unless is_valid_schema?(hash)

      hash = hash['metroStations'].map(&:symbolize_keys)
      hash = hash.each { |station| station[:color] = STATION_COLORS[station[:color]] }
      hash
    end
  end
end
