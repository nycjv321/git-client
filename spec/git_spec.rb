require_relative 'spec_helper'
require 'securerandom'

include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Git do
  describe '::init' do
    it 'initializes a git flow repo' do
      Git.init(tmp_dir)

      repository = Git::Repository.new(tmp_dir)
      git_flow = Git::Flow.new(repository)
      git_flow.init
      config = Git::Config.read(repository)
      expect(config['gitflow.branch.develop']).to_not be nil
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
  describe '.count' do
    it 'returns the number of commits in a repo' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')

      expect(Git.count(repository)).to eq 1
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
end