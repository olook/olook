require "spec_helper"

describe Payment do
  context "attributes validation" do
    it { should validate_presence_of(:payment_type) }
    it { should belong_to(:order) }
  end

  it "should return BoletoBancario" do
    payment = FactoryGirl.build(:payment, :payment_type => Payment::TYPE[:billet])
    payment.to_s.should eq("BoletoBancario")
  end

  it "should return DebitoBancario" do
    payment = FactoryGirl.build(:payment, :payment_type => Payment::TYPE[:debit])
    payment.to_s.should eq("DebitoBancario")
  end

  it "should return CartaoCredito" do
    payment = FactoryGirl.build(:payment, :payment_type => Payment::TYPE[:credit])
    payment.to_s.should eq("CartaoCredito")
  end
end
