# -*- encoding : utf-8 -*-
require "spec_helper"

describe LoyaltyProgramMailer do


  describe "loyalty program credits to be expired e-mail" do
    let(:member) { FactoryGirl.create(:member) }
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }

    before do
      user_credit.add({amount: 20})
      date = user_credit.credits.last.expires_at
           
      @mail = LoyaltyProgramMailer.send_expiration_warning(member, false, date)
    end

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      @mail.from.should include("avisos@olook.com.br")

    end

    it "sets 'to' attribute to passed member's email" do
      @mail.to.should include(member.email)
    end

    it "sets 'title' attribute" do
      @mail.subject.should == "Corra #{member.first_name}, seus R$ 20,00 em créditos expiram em sete dias!"
    end
  end

 
end
