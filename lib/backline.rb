require 'rugged'

require 'backline/version'
require 'backline/repository'
require 'backline/model'

module Backline
  class Error < StandardError; end

  class UnknownAttribute < Error
    def initialize(model_class, attribute)
      super "Unknown attribute '#{attribute}' for class #{model_class}"
    end
  end
end
