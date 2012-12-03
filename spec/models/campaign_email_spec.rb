# == Schema Information
#
# Table name: campaign_emails
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe CampaignEmail do
	describe "after create" do
		it "enqueues a CampaignEmailNotificationWorker in resque" do
      Resque.should_receive(:enqueue).with(CampaignEmailNotificationWorker, 'meu@email.com')
      FactoryGirl.create(:campaign_email, email: 'meu@email.com') 
    end
	end
end
