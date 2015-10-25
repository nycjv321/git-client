require_relative '../client'

module Git
  class Remote < Client
    BASE_COMMAND = "#{Git::BASE_COMMAND}"

    def initialize(repository)
      super(repository)
    end

    def delete!(name)
      output = `cd #{@repository.path}; #{BASE_COMMAND} push origin --delete #{name} 2>&1`
      unless output.include? 'deleted'
        raise(output)
      end
    end
  end
end


