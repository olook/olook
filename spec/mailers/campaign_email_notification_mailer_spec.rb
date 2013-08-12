# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CampaignEmailNotificationMailer do
  let(:campaign_email) { FactoryGirl.create(:campaign_email) }

  describe "#welcome_email" do
    let(:mail) { CampaignEmailNotificationMailer.welcome_email(campaign_email.email) }

    it "sets 'from' attribute to olook <bemvinda@my.olookmail.com.br>" do
      mail.from.should include("bemvinda@my.olookmail.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(campaign_email.email)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should == "Recebemos seu e-mail. Agora é hora de descobrir o seu estilo."
    end

    it "sets 'headers' with welcome_email category json" do
      mail.header.to_s.should match /X-SMTPAPI: {\"category\":\"welcome_email\"}/
    end

  end

end