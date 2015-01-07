require 'spec_helper'

describe Backline::Repository do

  let(:repository_path) { 'tmp/testing' }

  after { FileUtils.rm_rf(repository_path) }

  describe '.new' do
    before { Rugged::Repository.init_at(repository_path) }

    it 'should open the repository' do
      expect(described_class.new(repository_path))
        .to be_instance_of(described_class)
    end

    it 'should raise an error when the repository does not exist' do
      expect { expect(described_class.new('unknown-repository')) }
        .to raise_error(Backline::Error, /No such file or directory/)
    end

    it 'should yield itself' do
      expect { |b| described_class.new(repository_path, &b) }
        .to yield_with_args(described_class)
    end
  end

  describe '.create' do
    it 'should create a new bare git repository at the given location' do
      expect { described_class.create(repository_path) }
        .to change { File.exists?(repository_path) }.from(false).to(true)
    end

    it 'should open the created repository' do
      expect(described_class.create(repository_path))
        .to be_instance_of(described_class)
    end

    it 'should yield itself' do
      expect { |b| described_class.create(repository_path, &b) }
        .to yield_with_args(described_class)
    end
  end

  describe '.clone' do
    let(:remote_path) { 'tmp/remote' }

    before { Rugged::Repository.init_at(remote_path, :bare) }
    after { FileUtils.rm_rf(remote_path) }

    it 'should clone the git repository to the given location' do
      expect { described_class.clone(remote_path, repository_path) }
        .to change { File.exists?(repository_path) }.from(false).to(true)
    end

    it 'should open the created repository' do
      expect(described_class.clone(remote_path, repository_path))
        .to be_instance_of(described_class)
    end

    it 'should yield itself' do
      expect { |b| described_class.clone(remote_path, repository_path, &b) }
        .to yield_with_args(described_class)
    end
  end

  context 'persistence' do
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

    subject do
      described_class.new(repository_path) do |r|
        r.register dummy_class, 'dummy'
      end
    end

    before do
      repository = Rugged::Repository.init_at(repository_path)

      index = repository.index
      index.add(path: 'dummy/1', oid: repository.write("---\nfoo: foo\nbar: bar\n", :blob), mode: 0100644)
      index.add(path: 'dummy/2', oid: repository.write("---\nfoo: foo\nbar: bar\n", :blob), mode: 0100644)

      options = {
        tree: index.write_tree(repository),
        message: 'Initial commit',
        parents: [],
        update_ref: 'HEAD'
      }

      Rugged::Commit.create(repository, options)
    end

    describe '#find' do
      it 'should find the record' do
        expect(subject.find(dummy_class, 1))
          .to be_kind_of(dummy_class)
      end
    end

    describe '#all' do
      it 'should find the records' do
        expect(subject.all(dummy_class))
          .to match([an_instance_of(dummy_class), an_instance_of(dummy_class)])
      end
    end
  end
end
