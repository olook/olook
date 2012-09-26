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

  describe "loyalty program credits to be expired e-mail" do
    let(:member) { FactoryGirl.create(:member) }
    let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }  

    let(:mail) { 
      user_credit.add({amount: 20})
      LoyaltyProgramMailer.send_expiration_warning(member) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute" do
      # user_credit = loyalty_program_credit_type
      @credit_amount = LoyaltyProgramCreditType.credit_amount_to_expire(user_credit)      
      mail.subject.should == "#{member.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos vão expirar!"
    end
  end

  describe "loyalty program credits to be expired tomorrow e-mail" do
    let(:member) { FactoryGirl.create(:member) }
    let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }  

    let(:mail) { 
      user_credit.add({amount: 20})
      LoyaltyProgramMailer.send_expiration_warning(member, true) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(member.email)
    end

    it "sets 'title' attribute" do
      # user_credit = loyalty_program_credit_type
      @credit_amount = LoyaltyProgramCreditType.credit_amount_to_expire(user_credit)      
      mail.subject.should == "Corra #{member.first_name}, seus R$ #{('%.2f' % @credit_amount).gsub('.',',')} em créditos expiram amanhã!"
    end
  end  

end
