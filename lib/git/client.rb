require_relative 'client/version'
require 'open3'
require_relative 'client/branch'
require_relative 'client/history'
require_relative 'client/entry'

module Git
  BASE_COMMAND = 'git'

  def self.init(path)
    `#{BASE_COMMAND} init #{path} -q`
    Repository.new(path)
  end

  def self.count(repository)
    output = `cd #{repository.path}; #{BASE_COMMAND} rev-list HEAD --count  2>&1`.chomp
    if output.include? 'fatal'
      raise(output)
    end
    output.to_i
  end

  class Client
    def initialize(repository)
      @repository = repository
    end

    def self.clone(repo_path, dest)
      output = `#{BASE_COMMAND} clone #{repo_path} #{dest} --progress 2>&1`
      unless output.include? "Checking connectivity... done.\n"
        raise("Clone failed! See: #{output}")
      end
      Repository.new(dest)
    end

    def commit(message)
      output = `cd #{@repository.path}; #{BASE_COMMAND} commit -am "#{message}" 2>&1`
      unless output.include? message
        raise(output)
      end
    end

    def add(wildcard_pattern='*')
      `cd #{@repository.path}; #{BASE_COMMAND} add #{wildcard_pattern} 2>&1`
    end

    def fetch
      `cd #{@repository.path}; #{BASE_COMMAND} fetch --all 2>&1`
    end

    def delete(branch_name)
      output = `cd #{@repository.path}; #{BASE_COMMAND} branch -d #{branch_name}  2>&1`

      if output.include? 'which you are currently on'
        raise(output)
      end
    end

    def delete!(branch_name)
      output = `cd #{@repository.path}; #{BASE_COMMAND} branch -D #{branch_name}  2>&1`

      if output.include? 'which you are currently on'
        raise(output)
      end
    end

    def branch(name)
      output = `cd #{@repository.path}; #{BASE_COMMAND} checkout -b "#{name}"  2>&1`
      unless output.include? 'Switched to'
        raise(output)
      end
      Branch.new(@repository, name)
    end

    def checkout(name)
      output = `cd #{@repository.path}; #{BASE_COMMAND} checkout "#{name}"  2>&1`
      unless output.include? 'Switched to' or output.include?('Already on')
        raise(output)
      end
      Branch.new(@repository, name)
    end

    def remote_url
      URI(`cd #{@repository.path}; #{BASE_COMMAND} config --get remote.origin.url 2>&1`.chomp)
    end

    def branches
      `cd #{@repository.path}; #{BASE_COMMAND} branch`.split("\n").map { |branch| branch.gsub(' ', '').gsub('*', '') }
    end

    def history(start_tag=nil, end_tag=nil)
      if start_tag.nil? || end_tag.nil?
        output = `cd #{@repository.path}; #{BASE_COMMAND}  --no-pager log --pretty=format:"%aN::%aE::%h::%s" 2>&1`
      else
        output = `cd #{@repository.path}; #{BASE_COMMAND}  --no-pager log --pretty=format:"%aN::%aE::%h::%s" #{start_tag}..#{end_tag} 2>&1`
      end
      history = History.new

      raw_entries = output.split("\n").reverse
      raw_entries.each do |raw_entry|
        entry_attributes = raw_entry.split('::')
        entry = Entry.new
        entry.author = entry_attributes[0]
        entry.email = entry_attributes[1]
        entry.abbreviated_commit_hash = entry_attributes[2]
        entry.message = entry_attributes[3]
        history << entry
      end
      history
    end

    def push(include_tags, repo='origin', refspec='')
      if include_tags
        output = `cd #{@repository.path}; #{BASE_COMMAND} push #{repo} #{refspec} --tags --progress 2>&1`
      else
        output = `cd #{@repository.path}; #{BASE_COMMAND} push #{repo} #{refspec} --progress 2>&1`
      end
      if output.include? 'fatal'
        raise(output)
      end
    end
    def annotated_tag(version, message)
      output = `cd #{@repository.path}; #{BASE_COMMAND} tag -a #{version} -m "#{message}" 2>&1`
      if output.include? 'fatal'
        raise(output)
      end
    end
    def lightweight_tag(version)
      output = `cd #{@repository.path}; #{BASE_COMMAND} tag #{version} 2>&1`
      if output.include? 'fatal'
        raise(output)
      end
    end
  end
end

