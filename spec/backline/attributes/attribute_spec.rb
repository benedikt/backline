require 'spec_helper'

describe Backline::Attributes::Attribute do
  subject { described_class.new(:foo, bar: :baz) }

  describe '#name' do
    it 'should be a String' do
      expect(subject.name).to be_kind_of(String)
    end
  end

  describe '#getter_method' do
    it 'should be generate the correct getter method name' do
      expect(subject.getter_method).to eq('foo')
    end
  end

  describe '#setter_method' do
    it 'should be generate the correct setter method name' do
      expect(subject.setter_method).to eq('foo=')
    end
  end
end