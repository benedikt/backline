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

  describe '.new' do
    it 'should raise an error message when a given attribute is unkown' do
      expect { dummy_class.new(unknown: :value) }
        .to raise_error(Backline::UnknownAttribute)
    end

    it 'should set the given attributes when they are known' do
      dummy_class.attribute(:foo)
      model = dummy_class.new(foo: :bar)
      expect(model.foo).to eq(:bar)
    end

    it 'should yield itself' do
      expect { |b| dummy_class.new(&b) }.to yield_with_args(dummy_class)
    end
  end
end
