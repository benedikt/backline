module Backline
  class Transaction
    def initialize(repository)
      @repository = repository
      @git = repository.git
      @index = git.index

      index.read_tree(tree) unless git.empty?
    end

    def save(model)
      oid = git.write(model.class.dump(model), :blob)

      index.add({
        path: repository.path_for(model),
        oid: oid,
        mode: 0100644
      })
    end

    def delete(model)
      index.remove(repository.path_for(model))
    end

    def commit(message, options = {})
      options = options.merge({
        tree: index.write_tree(git),
        message: message,
        parents: git.empty? ? [] : [git.head.target].compact,
        update_ref: 'HEAD'
      })

      Rugged::Commit.create(git, options) if changes?
    end

    def rollback
      @index.reload
    end

    def changes?
      git.empty? || @index.diff(tree).size > 0
    end

  private

    attr_reader :repository, :index, :git

    def tree
      git.head.target.tree
    end

  end
end
