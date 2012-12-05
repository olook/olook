require 'spec_helper'

describe Users::ExpirationHelper do
  context "#user_expiration_month" do
    let(:now) { DateTime.now }
    let(:user) { FactoryGirl.create(:user, created_at: now) }

    it "returns the expiration month for a given user formatted correctly" do
      month_str = "%02d" % (now + 7.days).to_date.month.to_s
      helper.user_expiration_month(user).should eq month_str
    end
  end

  context "#user_expiration_day" do
    let(:now) { DateTime.now }
    let(:user) { FactoryGirl.create(:user, created_at: now) }

    it "returns the expiration day for a given user formatted correctly" do
      day_str = "%02d" % (now + 7.days).to_date.day.to_s
      helper.user_expiration_day(user).should eq day_str
    end
  end
end