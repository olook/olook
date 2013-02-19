# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:product) { FactoryGirl.create(:basic_shoe) }

  describe "#send_share_message_for" do
    informations = { name_from: "User name", email_from: "user@email.com", emails_to_deliver: "user_friend@email.com" }
    let!(:mail) { ShareProductMailer.send_share_message_for(product, informations) }

    it "sets 'from' attribute to olook email" do
      mail.from.should include("vip@o.conviteolook.com.br")
    end

    it "sets 'reply_to' attribute to user email" do
      mail.reply_to.should include(informations[:email_from])
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(informations[:emails_to_deliver])
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should eq product.id.to_s
    end

  end
end
