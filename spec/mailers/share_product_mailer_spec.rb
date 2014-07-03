# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:product) { FactoryGirl.create(:shoe) }

  describe "#send_share_message_for" do
    informations = { name_from: "User name", email_from: "user@email.com", email_body: "A Olook é linda cara!" }
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
    context "on mail subject" do
      it "include user name" do
        expect(mail.subject).to include(informations[:name_from].capitalize)
      end

      it "include category" do
        expect(mail.subject).to include("um #{product.category_humanize.downcase}")
      end
    end
  end
end
