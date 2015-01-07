require 'spec_helper'

describe Backline::Transaction do

  let(:repository_path) { 'tmp/testing' }
  let(:repository) do
    Backline::Repository.create(repository_path) do |r|
      r.register dummy_class
    end
  end

  let(:dummy_class) do
    Class.new do
      include Backline::Model

      def self.name
        'Dummy'
      end

      attribute :foo
    end
  end

  after { FileUtils.rm_rf(repository_path) }

  subject { described_class.new(repository) }

  describe '.commit' do
    let(:model) { dummy_class.new(id: 1, foo: 'bar') }
    let(:message) { 'Commit message' }

    before do
      subject.save(model)
      subject.commit(message)
    end

    it 'should create a new commit' do
      expect(repository.git.last_commit.message).to eq(message)
    end

    it 'should apply the requested changes' do
      expect(repository.find(dummy_class, 1)).to be
    end

    it 'should not create a commit when nothing was changed' do
      transaction = described_class.new(repository)
      transaction.save(model)

      expect { transaction.commit(message) }
        .to_not change(repository.git, :last_commit)
    end
  end
end