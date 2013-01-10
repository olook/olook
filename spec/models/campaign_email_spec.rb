require 'spec_helper'

describe CampaignEmail do

   let(:campaign_email) {FactoryGirl.create(:campaign_email, email: 'meu@email.com')}
   let(:user) {FactoryGirl.create(:user, email: 'meu@email.com')}

  describe "after create" do
	it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      campaign_email
    end

    it "should set turned_user to true on creation" do
      campaign_email.turned_user.should be_false
    end
  end

  describe "on user creation" do
    it "should set turned_user to true" do
      campaign_email
      user
      campaign_email.reload
      campaign_email.turned_user.should be_true
    end
  end
end
