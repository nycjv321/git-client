module Git
  class Config

    def initialize(repository)
      @repository = repository
      @config = Hash[list.split("\n").map { |s| s.split("=") }]
    end

    def self.read(repository)
      Config.new(repository)
    end

    def list
      `cd #{@repository.path}; #{BASE_COMMAND} config --list`
    end
    :private


    def [](key)
      @config[key]
    end
  end
end