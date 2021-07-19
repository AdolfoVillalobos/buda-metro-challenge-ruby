# recover_path.rb

module Metro
  # The Metro::RecoverPath class implements an utility to
  # recursively obtain the path to a target, given a
  # hash of parents.
  class RecoverPath
    def initialize(source, parents)
      @source = source
      @parents = parents
    end

    # Recursively recovers the path to target as an array of stations
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
