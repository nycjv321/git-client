require_relative '../client'

module Git
  class Flow < Client
    BASE_COMMAND = "#{Git::BASE_COMMAND} flow"

    def initialize(repository)
      super(repository)
    end

    def self.init(repository)
      `cd #{repository.path}; #{BASE_COMMAND} init -d`
    end

    def init
      Flow.init(@repository)
    end
  end
end

