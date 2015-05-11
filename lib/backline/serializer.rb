require 'backline/serializer/yaml'

module Backline
  module Serializer
    extend ActiveSupport::Concern

    included do
      class_attribute :serializer, instance_accessor: false
      self.serializer = Backline::Serializer::YAML
    end

  end
end
