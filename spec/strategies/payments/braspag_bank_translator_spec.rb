# -*- encoding : utf-8 -*-
describe Payments::BraspagBankTranslator do 

  context "using Redecard acquirer" do

    before :each do
      Setting.stub(:acquirer).and_return("redecard")
    end

    it "should return right value for visa" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Visa")
      gateway_code.should == :redecard_visa
    end

    it "should return right value for mastercard" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Mastercard")
      gateway_code.should == :redecard_mastercard
    end

    it "should return right value for Amex" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("AmericanExpress")
      gateway_code.should == :amex_2p
    end

    it "should return right value for diners" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Diners")
      gateway_code.should == :redecard_diners
    end

    it "should return right value for hipercard" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Hipercard")
      gateway_code.should == :sitef_hipercard
    end    

  end

  context "using Cielo acquirer" do
    before :each do
      Setting.stub(:acquirer).and_return("cielo")
    end

    it "should return right value for visa" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Visa")
      gateway_code.should == :cielo_visa
    end       

    it "should return right value for visa" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Mastercard")
      gateway_code.should == :cielo_mastercard
    end    

    it "should return right value for visa" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("AmericanExpress")
      gateway_code.should == :cielo_amex
    end

    it "should return right value for diners" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Diners")
      gateway_code.should == :cielo_diners
    end

    it "should return right value for hipercard" do
      gateway_code = Payments::BraspagBankTranslator.payment_method_for("Hipercard")
      gateway_code.should == :sitef_hipercard
    end       


  end
  
end