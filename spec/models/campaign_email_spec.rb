require 'spec_helper'

describe CampaignEmail do

   let(:campaign_email) {FactoryGirl.create(:campaign_email, email: 'meu@email.com')}
   let(:user) {FactoryGirl.create(:user, email: 'meu@email.com')}
   let(:utm_params) {{utm_source: "source", utm_medium: "medium", utm_content: "content", utm_campaign: "campaign"}}

   describe "#validations" do
     it { should validate_presence_of :email }
     it { should validate_uniqueness_of(:email) }
   end

  describe "after create" do
	it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      campaign_email
    end

    it "converted_user should be false on creation" do
      campaign_email.converted_user.should be_false
    end
  end

  describe "on presence of utm params" do
    it "#set_utm_info" do
      campaign_email.set_utm_info utm_params
      campaign_email.reload
      campaign_email.utm_medium.should eq("medium")
      campaign_email.utm_source.should eq("source")
      campaign_email.utm_campaign.should eq("campaign")
      campaign_email.utm_content.should eq("content")
    end
  end
end
