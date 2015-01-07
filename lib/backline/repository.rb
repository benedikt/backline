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
      entry = tree.path(path.to_s)
      load_from_entry(type, entry)
    end

    def all(type)
      tree = subtree_for(type)
      tree.enum_for(:each_blob).map do |entry|
        load_from_entry(type, entry)
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

    def load_from_entry(type, entry)
      content = repository.lookup(entry[:oid]).content
      type.load(content).tap do |model|
        model.id = entry[:name]
      end
    end

    def subtree_for(type)
      oid = tree.path(mapping[type])[:oid]
      repository.lookup(oid)
    end

  end
end
