# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:member) { FactoryGirl.create(:member) }

  describe "#welcome_email" do
    let(:mail) { MemberMailer.welcome_email(member) }

    it "sets 'from' attribute to olook <bemvinda@olook1.com.br>" do
      mail.from.should include("bemvinda@olook1.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should == "#{member.name}, use agora mesmo seus 20% de desconto!"
    end

    it "sets 'headers' with welcome_email category json" do
      mail.header.to_s.should match /X-SMTPAPI: {\"category\":\"welcome_email\"}/
    end

  end
end