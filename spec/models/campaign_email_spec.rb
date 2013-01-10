require 'spec_helper'

describe CampaignEmail do

   let(:campaign_email) {FactoryGirl.create(:campaign_email, email: 'meu@email.com')}

  describe "after create" do
	it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      campaign_email
    end

    it "should set turned_user to true" do
      campaign_email.turned_user.should be_false
    end
  end
end
