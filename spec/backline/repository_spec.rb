require 'spec_helper'

describe Backline::Repository do

  let(:repository_path) { 'tmp/testing' }

  after { FileUtils.rm_rf(repository_path) }

  describe '.new' do
    before { Rugged::Repository.init_at(repository_path, :bare) }

    it 'should open the repository' do
      expect(described_class.new(repository_path))
        .to be_instance_of(described_class)
    end

    it 'should raise an error when the repository does not exist' do
      expect { expect(described_class.new('unknown-repository')) }
        .to raise_error(Backline::Error, /No such file or directory/)
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
  end

end
