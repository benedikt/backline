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
      @repository = Rugged::Repository.new(path)
      yield self if block_given?
    rescue Rugged::OSError => e
      raise(Backline::Error, e.message)
    end

    def register(type, path = nil)
      mapping[type] = (path || type.name.underscore).to_s
    end

    def find(type, path)
      tree = subtree_for(type)
      oid = tree.path(path.to_s)[:oid]
      load_from_oid(type, oid)
    end

    def all(type)
      tree = subtree_for(type)
      tree.enum_for(:each_blob).map do |entry|
        load_from_oid(type, entry[:oid])
      end
    end

  private

    attr_reader :repository

    def mapping
      @mapping ||= {}
    end

    def tree
      repository.head.target.tree
    end

    def load_from_oid(type, oid)
      content = repository.lookup(oid).content
      type.load(content)
    end

    def subtree_for(type)
      oid = tree.path(mapping[type])[:oid]
      repository.lookup(oid)
    end

  end
end
