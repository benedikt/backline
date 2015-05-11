require 'backline/transaction'
require 'backline/blob'

module Backline
  class Repository

    def self.create(path, &block)
      Rugged::Repository.init_at(path, :bare)

      new(path, &block)
    end

    def self.clone(remote_path, local_path, &block)
      Rugged::Repository.clone_at(remote_path, local_path, bare: true)

      new(local_path, &block)
    end

    def initialize(path)
      @git = Rugged::Repository.new(path)
      yield self if block_given?
    rescue Rugged::OSError => e
      raise(Backline::Error, e.message)
    end

    def register(type, path = nil)
      mapping[type] = (path || type.name.underscore).to_s
    end

    def find(type, path)
      tree = subtree_for(type)
      entry = tree.path(path.to_s)
      blob = blob_from_entry(entry)

      type.load(blob)
    end

    def all(type)
      tree = subtree_for(type)
      tree.enum_for(:each_blob).map do |entry|
        blob = blob_from_entry(entry)
        type.load(blob)
      end
    end

    def transaction(message = "Commit generated using Backline")
      Transaction.new(self).tap do |transaction|
        if block_given?
          yield transaction
          transaction.commit(message)
        end
      end
    end

    attr_reader :git

    def path_for(model)
      "#{mapping[model.class]}/#{model.id}"
    end

  private

    def mapping
      @mapping ||= {}
    end

    def tree
      git.head.target.tree
    end

    def blob_from_entry(entry)
      content = git.lookup(entry[:oid]).content
      Backline::Blob.new(entry[:name], content)
    end

    def load_from_blob(type, blob)
      type.load(blob)
    end

    def subtree_for(type)
      oid = tree.path(mapping[type])[:oid]
      git.lookup(oid)
    end

  end
end
