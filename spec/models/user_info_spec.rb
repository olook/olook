require 'spec_helper'

describe UserInfo do
    describe "validation" do
    it { should belong_to(:user) }
  end
end
