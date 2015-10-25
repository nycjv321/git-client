require_relative 'spec_helper'
require 'securerandom'

include RSpec

describe Git::Flow do
  describe '::BASE_COMMAND' do
    it 'returns the base git flow command' do
      expect(Git::Flow::BASE_COMMAND).to eq('git flow')
    end
  end
end