require 'spec_helper'

describe Backline::Persistence do

  let(:dummy_class) do
    Class.new do
      include Backline::Model

      def self.name
        'Dummy'
      end

      attribute :foo
      attribute :bar
    end
  end

  describe '#load' do
    let(:blob) { "---\nfoo: foo\nbar: bar\nbaz: baz\n" }

    subject { dummy_class.load(blob) }

    it 'should instantiate a new model' do
      expect(subject).to be_instance_of(dummy_class)
    end

    it 'should set the known attributes' do
      expect(subject.foo).to eq('foo')
      expect(subject.bar).to eq('bar')
    end

    it 'should ignore the unknown attributes' do
      expect(subject.attributes).to_not have_key('baz')
    end

    it 'should fail to load unsafe data' do
      expect { dummy_class.load("--- !ruby/object {}\n") }
        .to raise_error(Backline::Error)
    end
  end

  describe '#dump' do
    subject { dummy_class.new(foo: 'foo', bar: 'bar') }

    it 'should dump the given model to a blob' do
      expect(dummy_class.dump(subject)).to eq("---\nfoo: foo\nbar: bar\n")
    end
  end
end
