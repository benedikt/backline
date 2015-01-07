module Backline
  module Model
    module Attributes
      class Attribute < Struct.new(:name, :options)

        def initialize(name, options = {})
          super(name.to_s, options)
        end

        def getter_method
          name
        end

        def setter_method
          "#{name}="
        end

      end
    end
  end
end