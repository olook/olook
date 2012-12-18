require 'spec_helper'

describe CampaignEmail do
	describe "after create" do
		it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      FactoryGirl.create(:campaign_email, email: 'meu@email.com')
    end
  end
end
