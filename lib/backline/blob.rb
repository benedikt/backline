require 'active_model'

module Backline
  class Blob < SimpleDelegator

    def initialize(path, data)
      @path = path
      super(StringIO.new(data))
    end

    attr_accessor :path

  end
end
