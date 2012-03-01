require "spec_helper"

describe Tracking do
  describe 'relationships' do
    it { should belong_to :user }
  end
end