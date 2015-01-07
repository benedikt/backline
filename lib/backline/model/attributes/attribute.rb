module Backline
  module Model
    module Attributes
      class Attribute < Struct.new(:name, :options)

        def getter_method
          name.to_s
        end

        def setter_method
          "#{name}="
        end

      end
    end
  end
end