# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CreditCardNumberValidator do
  let(:order) { FactoryGirl.create(:order) }
  let(:credit_card) { FactoryGirl.build(:credit_card, :order => order, :credit_card_number => '4111111111111111') }
  subject { described_class.new({}) }

  xit "should add invalid message for invalid Credit Card" do
    credit_card.credit_card_number = '41111111111111113'
    subject.validate(credit_card)
    credit_card.errors.should_receive(:add).with(:credit_card_number, String.any_instance)
  end

  xit "should not create errors for a valid Credit Card" do
    credit_card.credit_card_number = '41111111111111111'
    subject.validate(credit_card)
    credit_card.errors.should_not_receive(:add).with(:credit_card_number, String.any_instance)
  end  

end