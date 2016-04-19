require 'yaml'

module Backline
  module Serializer
    module YAML
      def self.dump(data)
        ::YAML.dump(data)
      end

      def self.load(data)
        ::YAML.safe_load(data)
      end
    end
  end
end
