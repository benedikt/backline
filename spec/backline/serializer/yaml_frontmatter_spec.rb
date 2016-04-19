require 'spec_helper'

describe Backline::Serializer::YAMLFrontmatter do

  let(:serialized) do
    "---\nfoo: bar\n---\nHello World"
  end

  let(:deserialized) do
    {
      'foo' => 'bar',
      'content' => 'Hello World'
    }
  end

  describe '.load' do
    it 'should properly load the serialized data' do
      expect(described_class.load(serialized)).to eq(deserialized)
    end
  end

  describe '.dump' do
    it 'should properly dump the deserialized data' do
      expect(described_class.dump(deserialized)).to eq(serialized)
    end
  end

end
