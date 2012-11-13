# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CampaignEmailNotificationWorker do
	let(:campaign_email) { FactoryGirl.create(:campaign_email) }
  let(:mock_mail) { double :mail }

  it "should send the welcome e-mail to the email stored" do
    mock_mail.should_receive(:deliver)
    CampaignEmailNotificationMailer.should_receive(:welcome_email).with(campaign_email.email).and_return(mock_mail)

    described_class.perform(campaign_email.email)
  end
end