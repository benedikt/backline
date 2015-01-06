module Backline
  class Repository

    def self.create(path)
      Rugged::Repository.init_at(path, :bare)

      new(path)
    end

    def self.clone(remote_path, local_path)
      Rugged::Repository.clone_at(remote_path, local_path, bare: true)

      new(local_path)
    end

    def initialize(path)
      @repository = Rugged::Repository.bare(path)
    rescue Rugged::OSError => e
      raise(Backline::Error, e.message)
    end

  end
end
