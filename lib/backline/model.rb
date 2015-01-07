require 'active_model'

require 'backline/model/attributes'

module Backline
  module Model
    extend ActiveSupport::Concern
    include ActiveModel::Model

    include Attributes

    def initialize(attributes = {})
      attributes.each do |name, value|
        method = "#{name}="
        raise(Backline::UnknownAttribute.new(self.class, name)) unless respond_to?(method)
        public_send(method, value)
      end

      yield self if block_given?
    end
  end
end
