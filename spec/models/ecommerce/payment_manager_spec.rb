require 'spec_helper'

describe PaymentManager do

  let(:order1) { FactoryGirl.create(:order) }
  let(:order2) { FactoryGirl.create(:order) }
  let(:order3) { FactoryGirl.create(:order) }
  let(:payment_manager) { PaymentManager.new }
  let(:billet) { FactoryGirl.create(:billet, :order => order1) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order2) }
  let(:debit) { FactoryGirl.create(:debit, :order => order3) }

  context "checking initialization attributes" do
    it "should verify @billet and ensure that it's attributed right" do
      payment_manager.billet.should eq("Billet")
    end

    it "should verify @credit_card and ensure that it's attributed right" do
      payment_manager.credit_card.should eq("CreditCard")
    end

    it "should verify @debit and ensure that it's attributed right" do
      payment_manager.debit.should eq("Debit")
    end
  end

  context "expiring payments" do
    it "should expires all expired billet orders" do
      billet.order.waiting_payment
      billet.payment_expiration_date = 3.days.ago
      billet.save
      billet.reload
      payment_manager.expires_billet
      billet.order.state.should eq("canceled")
    end

    it "should expires all expired credit card orders" do
      credit_card.order.waiting_payment
      credit_card.payment_expiration_date = 3.days.ago
      credit_card.save
      credit_card.reload
      payment_manager.expires_credit_card
      credit_card.order.state.should eq("canceled")
    end

    it "should expires all expired debits" do
      debit.order.waiting_payment
      debit.payment_expiration_date = 3.days.ago
      debit.save
      debit.reload
      payment_manager.expires_debit
      debit.order.state.should eq("canceled")
    end
  end
end

