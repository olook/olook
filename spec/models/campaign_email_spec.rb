require 'spec_helper'

describe CampaignEmail do
	describe "after create" do
		it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, anything)
      FactoryGirl.create(:campaign_email)
    end
	end
end
