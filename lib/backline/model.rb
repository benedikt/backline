require 'active_model'

require 'backline/model/attributes'

module Backline
  module Model
    extend ActiveSupport::Concern
    include ActiveModel::Model

    include Attributes
  end
end
