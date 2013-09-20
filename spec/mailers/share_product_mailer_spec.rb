# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:product) { FactoryGirl.create(:shoe) }

  describe "#send_share_message_for" do
    informations = { name_from: "User name", email_from: "user@email.com" }
    email_receiver = "user_friend@email.com"

    let!(:mail) { ShareProductMailer.send_share_message_for(product, informations, email_receiver) }

    it "sets 'from' attribute to olook email" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'reply_to' attribute to user email" do
      mail.reply_to.should include(informations[:email_from])
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(email_receiver)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should eq "#{ informations[:name_from].upcase } viu o #{ product.category_humanize } #{ product.name } no site da olook e lembrou de você"
    end

  end
end
