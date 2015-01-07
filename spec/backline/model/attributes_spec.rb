require 'spec_helper'

describe Backline::Model::Attributes do

  let(:dummy_class) do
    Class.new do
      include Backline::Model::Attributes
    end
  end

  subject { dummy_class.new }

  describe '.attribute' do
    it 'should add the new attribute to the attributes hash' do
      expect { dummy_class.attribute(:foo, bar: :baz) }
        .to change(dummy_class.attributes, :count).by(1)
    end

    it 'should generate a getter method' do
      dummy_class.attribute(:foo)
      expect(subject).to respond_to(:foo)
      expect(subject.foo).to eq(nil)
    end

    it 'should generate a setter method' do
      dummy_class.attribute(:foo)
      expect(subject).to respond_to(:foo=)
      expect(subject.foo = :bar).to eq(:bar)
    end
  end

  describe '.attribute_names' do
    it 'should return the attribute names' do
      dummy_class.attribute(:foo)
      expect(dummy_class.attribute_names).to eq(['foo'])
    end
  end

  describe '#read_attribute' do
    before do
      subject.attributes['foo'] = :bar
    end

    it 'should return the requested attributes value' do
      expect(subject.read_attribute(:foo)).to eq(:bar)
    end
  end

  describe '#write_attribute' do
    it 'should store the given attributes value' do
      expect { subject.write_attribute(:foo, :bar) }
        .to change(subject, :attributes).from({}).to('foo' => :bar)
    end
  end

end
