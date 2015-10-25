require_relative 'spec_helper'
require 'securerandom'

include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Git::Release do
  describe '::BASE_COMMAND' do
    it 'returns the base git flow command' do
      expect(Git::Release::BASE_COMMAND).to eq('git flow release')
    end
  end
  describe '.start' do
    it 'starts a new release branch without error' do

      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')
      Git::Flow.init(repository)
      git_flow_release = Git::Release.new(repository, 'test')
      git_flow_release.start

    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
end