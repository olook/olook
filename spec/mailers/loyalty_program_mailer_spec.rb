# -*- encoding : utf-8 -*-
require "spec_helper"

describe LoyaltyProgramMailer do
  describe "loyalty program credits enabled e-mail" do
    let(:member) { FactoryGirl.create(:member) }
    let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }  

    let(:mail) { 
      user_credit.add({amount: 20})
      LoyaltyProgramMailer.send_enabled_credits_notification(member) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute" do
      mail.subject.should == "#{member.first_name}, você tem R$ #{('%.2f' % member.user_credits_for(:loyalty_program).total).gsub('.',',')} em créditos disponíveis para uso."
    end
  end

end
