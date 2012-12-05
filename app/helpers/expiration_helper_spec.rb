require 'spec_helper'

describe Users::ExpirationHelper do
  context "#user_expiration_date" do
    let(:now) { DateTime.now }
    let(:user) { FactoryGirl.create(:user, created_at: now) }

    it "returns the expiration date for a given user" do
      helper.user_expiration_date(user).should eq (now + 7.days).to_date
    end

  end
end