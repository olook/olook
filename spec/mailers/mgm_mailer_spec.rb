# encoding: utf-8
require "spec_helper"

describe MGMMailer do
  let(:member) { FactoryGirl.create(:member) }
  let(:inviter) {mock(User, first_name: "Inviter", email: "testeolook@gmail.com")}
  describe "registered invitee e-mail" do
    let(:mail) { 
      
      member.stub(:inviter => inviter)
      MGMMailer.send_registered_invitee_notification(member) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(inviter.email)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should == "#{member.first_name} se cadastrou pelo seu convite!"
    end

    it "should mention correctly the inviter as well as the invitee" do
      mail.body.to_s["#{member.first_name}</span> comprar pela primeira vez na olook, você ganhará <b>R$ 20</b> em créditos."].should_not be_nil
    end
  end

  describe "invitee bought for the first time e-mail" do
    let(:mail) { 
      
      member.stub(:inviter => inviter)
      MGMMailer.send_first_purchase_by_invitee_notification(member) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(inviter.email)
    end

    it "sets 'title' attribute welcoming the new member" do
      mail.subject.should == "#{member.first_name} fez uma compra e você ganhou R$ 20."
    end
  end

end
