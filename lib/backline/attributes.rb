require 'backline/attributes/attribute'

module Backline
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes, instance_reader: false
      self.attributes = {}
    end

    module ClassMethods
      def attribute(name, options = {})
        Attribute.new(name, options.merge(model_class: self)).tap do |attribute|
          attributes[attribute.name] = attribute
          generate_accessors(attribute)
        end
      end

      def attribute_names
        attributes.keys
      end

    private

      def generate_accessors(attribute)
        generate_getter(attribute)
        generate_setter(attribute)
      end

      def generate_getter(attribute)
        generated_methods.module_eval do
          define_method(attribute.getter_method) do
            read_attribute(attribute.name)
          end
        end
      end

      def generate_setter(attribute)
        generated_methods.module_eval do
          define_method(attribute.setter_method) do |value|
            write_attribute(attribute.name, value)
          end
        end
      end

      def generated_methods
        @generated_methods ||= Module.new.tap { |mod| include(mod) }
      end
    end

    def read_attribute(name)
      attributes[name.to_s]
    end

    def write_attribute(name, value)
      attributes[name.to_s] = value
    end

    def attributes
      @attributes ||= {}
    end
  end
end