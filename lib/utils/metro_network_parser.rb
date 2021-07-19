# frozen_string_literal: true

require 'json'
require 'json-schema'

require 'active_support'
require 'active_support/core_ext'

require 'getoptlong'

module Metro
  class MetroNetworkParser
    JSON_SCHEMA = File.join('lib', 'utils', 'schemas', 'metro_network_schema.json')
    def self.is_valid_schema?(hash)
      JSON::Validator.validate(JSON_SCHEMA, hash)
    end

    def self.parse(filename)
      path = File.join(File.dirname(__FILE__), '../..', filename)
      file_content = File.open(path).read
      hash = JSON.parse(file_content)

      raise 'Invalid JSON' unless is_valid_schema?(hash)

      hash['metroStations'].map(&:symbolize_keys)
    end
  end
end
