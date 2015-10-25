require_relative 'spec_helper'
require 'securerandom'

include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Git::Config do
  describe '#[]' do
    it 'returns a value based on a key of git config of the selected repository' do
      Git.init(tmp_dir)
      config = Git::Config.read(Git::Repository.new(tmp_dir))
      expect(config['core.bare']).to_not be nil
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
end