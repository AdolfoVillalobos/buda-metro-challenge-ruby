module Metro
  class RecoverPath
    def initialize(source, parents)
      @source = source
      @parents = parents
    end

    def recover_path(target)
      if target == @source
        [@source]
      else
        parent = @parents[target]
        return recover_path(parent) + [target] if parent

        []
      end
    end
  end
end
