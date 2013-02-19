# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:product) { FactoryGirl.create(:basic_shoe) }

  describe "#welcome_email" do
    informations = { name_from: "User name", email_from: "user@email.com", emails_to: "user_friend@email.com" }
    let!(:mail) { ShareProductMailer.send_share_message_for(product, informations) }

    it "sets 'from' attribute to olook user email" do
      mail.from.should include(informations[:email_from])
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(informations[:emails_to])
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should eq product.id.to_s
    end
  end
end
