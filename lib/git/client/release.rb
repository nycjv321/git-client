require_relative 'flow'

module Git
  class Release < Flow
    BASE_COMMAND = "#{Flow::BASE_COMMAND} release"

    def initialize(repository, version_number)
      super(repository)
      @version_number = version_number
    end

    def start
      output = `cd #{@repository.path}; #{BASE_COMMAND} start #{@version_number}`
      unless output.include? "A new branch 'release/#{@version_number}' was created"
        raise(output)
      end
      if output.include? 'have diverged'
        raise(output)
      end
    end

    def branch
      git = Git::Client.new(@repository)
      git.branches.select { |branch|
        branch =~ /release\/(.*)/
      }
    end

    def publish
      output = `cd #{@repository.path}; #{BASE_COMMAND} publish #{@version_number}`
      unless output.include? 'You are now on'
        raise(output)
      end
    end

    def finish(sign=false)
      if sign
        `#{BASE_COMMAND} finish -s #{@version_number}`
      else
        `#{BASE_COMMAND} finish #{@version_number}`
      end
    end
  end
end


