# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CreditCardNumberValidator do
  let(:order) { FactoryGirl.create(:order) }
  let(:credit_card) { FactoryGirl.build(:credit_card, :order => order, :credit_card_number => '4111111111111111') }
  subject { described_class.new({}) }

  it "should add invalid message for invalid Credit Card" do
    credit_card.credit_card_number = '4111111111112114'
    credit_card.errors.should_receive(:add).with(:credit_card_number, I18n.t('activerecord.errors.models.credit_card.attributes.credit_card_number.invalid'))
    subject.validate(credit_card)
  end

  it "should not create errors for a valid Credit Card" do
    credit_card.credit_card_number = '41111111111111111'
    credit_card.errors.should_not_receive(:add).with(:credit_card_number, I18n.t('activerecord.errors.models.credit_card.attributes.credit_card_number.invalid'))
    subject.validate(credit_card)
  end  

  context "when handling amex cards" do
    it "adds an invalid message for an invalid Credit Card" do
      credit_card.credit_card_number = '345678904234565'
      credit_card.errors.should_receive(:add).with(:credit_card_number, I18n.t('activerecord.errors.models.credit_card.attributes.credit_card_number.invalid'))
      subject.validate(credit_card)
    end

    it "doesn't create errors for a valid Credit Card" do
      credit_card.credit_card_number = '378282246310005'
      credit_card.errors.should_not_receive(:add).with(:credit_card_number, I18n.t('activerecord.errors.models.credit_card.attributes.credit_card_number.invalid'))
      subject.validate(credit_card)
    end  
  end

end