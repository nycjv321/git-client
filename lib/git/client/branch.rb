require_relative '../client'

module Git
  class Branch

    def initialize(repository, name)
      @repository = repository
      @name = name
    end

    def current_abbreviated_hash
      if Git.count(@repository).eql? 1
        output = `cd #{@repository.path}; #{BASE_COMMAND} log --pretty=%h HEAD 2>&1`.chomp
      else
        output = `cd #{@repository.path}; #{BASE_COMMAND} log --pretty=%h HEAD^..HEAD 2>&1`.chomp
      end
      if output.include? 'fatal'
        raise(output)
      end
      output
    end
  end
end