# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberMailer do
  let(:member) { FactoryGirl.create(:member) }

  describe "#welcome_email" do
    let(:mail) { MemberMailer.welcome_email(member) }

    it "sets 'from' attribute to olook <bemvinda@my.olookmail.com.br>" do
      mail.from.should include("bemvinda@my.olookmail.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should == "#{member.name}, seja bem vinda! Seu cadastro foi feito com sucesso!"
    end

  end

  describe "#showroom_ready_email" do
    let(:mail) { MemberMailer.showroom_ready_email(member) }

    it "sets 'from' attribute to olook <avisos@my.olookmail.com.br>" do
      mail.from.should include("avisos@my.olookmail.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute describing that the showroom is ready for the user" do
      mail.subject.should == "#{member.name}, sua vitrine personalizada já está pronta!"
    end

  end
end