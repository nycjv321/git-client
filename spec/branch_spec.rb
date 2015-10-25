require_relative 'spec_helper'
require 'securerandom'

include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Git::Branch do
  describe '#abbreviated_commit_hash' do
    it 'returns the current branch\'s tips abbreviated commit hash if there is only one commit' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      `touch #{tmp_dir + '/temp_file'}`
      git.add
      git.commit('adding tmp file')
      branch = git.checkout('master')
      expect(branch.current_abbreviated_hash).to match(/^[\d|\w]{7}/)
    end
    it 'returns the current branch\'s tips abbreviated commit hash' do
      repository = Git.init(tmp_dir)
      git = Git::Client.new(repository)
      `touch #{tmp_dir + '/temp_file'}`
      `echo 'test' > #{tmp_dir + '/temp_file'}`

      git.add
      git.commit('adding tmp file')
      branch = git.branch('test')
      `echo 'test' > #{tmp_dir + '/temp_file'}`
      `echo 'another test' > #{tmp_dir + '/temp_file'}`

      git.commit('updating tmp file')

      expect(branch.current_abbreviated_hash).to match(/^[\d|\w]{7}/)
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
    before(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end

end
