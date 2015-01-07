require 'spec_helper'

describe Backline::Model do

  let(:dummy_class) do
    Class.new do
      include Backline::Model

      def self.name
        'Dummy'
      end
    end
  end

  subject { dummy_class.new }

  it_behaves_like 'ActiveModel'

end