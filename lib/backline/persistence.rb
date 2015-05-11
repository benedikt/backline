module Backline
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def load(blob)
        attributes = YAML.safe_load(blob)
        new(attributes.slice(*attribute_names)).tap do |model|
          model.id = blob.path
        end
      rescue StandardError => e
        raise(Backline::Error, e.message)
      end

      def dump(model)
        YAML.dump(model.attributes)
      end
    end
  end
end
