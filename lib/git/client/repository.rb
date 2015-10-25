require 'uri'
require 'tmpdir'
require_relative '../client'

module Git
  class Repository

    def initialize(repo)
      @repo = repo
    end

    def path
      @repo
    end

    def clone
      repo = @repo
      @path = Dir.tmpdir() + '/' + Repository.directory_name(repo)
      Git::Client.clone(repo, @path)
    end

    def self.directory_name(uri)
      path = uri.path
      if path.include? '/'
        path[path.rindex(/\//) + 1, path.length]
      else
        path
      end
    end
  end
end
