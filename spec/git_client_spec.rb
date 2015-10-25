require_relative 'spec_helper'
require 'securerandom'

include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Git::Client do
  describe '::BASE_COMMAND' do
    it 'returns the base git flow command' do
      expect(Git::BASE_COMMAND).to eq('git')
    end
  end
  describe '.init' do
    it 'initializes git repos' do
      output = Git.init(tmp_dir)
      expect(output).to be_a Git::Repository
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
    before(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
  describe '#commit' do
    it 'commits the current working copy to the local repo with no error' do

      git = Git::Client.new(Git.init(tmp_dir))
      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end

  describe '#commit_history' do
    it 'returns a hash of commits with author, email, and abbreviated hash info' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')
      first_hash_code = git.checkout('master').current_abbreviated_hash

      `echo "// some codez" >> #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('added some codez')

      second_hash_code = git.checkout('master').current_abbreviated_hash
      config = Git::Config.read(repository)

      history = git.history

      expected_history = []
      entry = {}
      entry[:author] = config['user.name']
      entry[:email] = config['user.email']
      entry[:abbreviated_commit_hash] = first_hash_code
      entry[:message] = 'adding tmp file'
      expected_history << entry
      entry = {}
      entry[:author] = config['user.name']
      entry[:email] = config['user.email']
      entry[:abbreviated_commit_hash] = second_hash_code
      entry[:message] = 'added some codez'
      expected_history << entry
      history.should eq expected_history
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
  describe '.branches' do
    it 'lists the current branches' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      git_flow = Git::Flow.new(repository)
      git_flow.init
      git_flow_release = Git::Release.new(repository, 'test')
      git_flow_release.start
      git.branches
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end

  describe '#delete' do
    it 'deletes a branch' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)

      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')

      git.branch('test')
      expect(git.branches).to include('test')
      git.branch('another_test')

      git.delete('test')
      expect(git.branches).to_not include('test')
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end

  describe '#delete!' do
    it 'deletes a branch' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)

      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')

      git.branch('test')

      git_flow = Git::Flow.new(repository)
      git_flow.init
      git_flow_release = Git::Release.new(repository, 'test')
      git_flow_release.start

      git.delete!('test')
      expect(git.branches).to_not include('test')
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
end

