# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Payments::BraspagBankTranslator do 

  context "using Redecard acquirer" do

    before :each do
      Setting.stub(:acquirer).and_return("redecard")
      Payments::BraspagBankTranslator.stub(:load_config).and_return({
        redecard: {visa: :redecard_visa, mastercard: :redecard_mastercard, americanexpress: :amex_2p, diners: :redecard_diners, hipercard: :sitef_hipercard, aura: :sitef_aura}
      })
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
      Payments::BraspagBankTranslator.stub(:load_config).and_return({
        cielo: {visa: :cielo_visa, mastercard: :cielo_mastercard, americanexpress: :cielo_amex, diners: :cielo_diners, hipercard: :sitef_hipercard, aura: :sitef_aura}
      })
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