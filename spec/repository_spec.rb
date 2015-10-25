require_relative 'spec_helper'
include Git

include RSpec

describe Repository do
  repo_uri = URI('https://github.com/nycjv321/monkey_patches.git')

  describe '#directory_name' do
    it "returns a repo's filename" do
      expect(Repository.directory_name(repo_uri)).to eq('monkey_patches.git')
    end
  end
  describe '.checkout' do
    system_temp = Dir.tmpdir
    it 'checkouts a repo' do
      expect(Dir.exist?(system_temp + '/' + Repository.directory_name(repo_uri))).to be_falsey
      repo = Repository.new(repo_uri)
      repo.clone
      expect(Dir.exist?(system_temp + '/' + Repository.directory_name(repo_uri))).to be_truthy
    end
    before(:all) do
      FileUtils.rm_rf(system_temp + '/' + Repository.directory_name(repo_uri))
    end
    after(:all) do
      FileUtils.rm_rf(system_temp + '/' + Repository.directory_name(repo_uri))
    end
  end
end