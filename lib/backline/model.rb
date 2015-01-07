require 'active_model'

require 'backline/attributes'
require 'backline/persistence'

module Backline
  module Model
    extend ActiveSupport::Concern
    include ActiveModel::Model

    include Attributes
    include Persistence

    def initialize(attributes = {})
      attributes.each do |name, value|
        method = "#{name}="
        raise(Backline::UnknownAttribute.new(self.class, name)) unless respond_to?(method)
        public_send(method, value)
      end

      yield self if block_given?
    end

    attr_accessor :id
  end
end
