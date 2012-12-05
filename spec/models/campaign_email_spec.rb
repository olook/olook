require 'spec_helper'

describe CampaignEmail do
	describe "after create" do
		it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      FactoryGirl.create(:campaign_email, email: 'meu@email.com')
    end
  end

  describe ".with_discount_about_to_expire_in_48_hours" do
    context "searching for emails that have discount" do
      let!(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - 5.days ) }
      it "returns emails" do
        described_class.with_discount_about_to_expire_in_48_hours.should eq([campaign_email])
      end

      it "shouldn't return emails" do
        campaign_email.created_at = DateTime.now - 6.days
        campaign_email.save

        described_class.with_discount_about_to_expire_in_48_hours.should eq([])
      end
    end
  end
end
