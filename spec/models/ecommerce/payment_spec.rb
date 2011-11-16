require "spec_helper"

describe Payment do
  subject { FactoryGirl.build(:payment, :payment_type => Payment::TYPE[:credit]) }

  context "attributes validation" do
    it { should be_valid }

    describe "when is paid with credit card" do
      it "requires user_name" do
        subject.user_name = nil
        subject.valid?.should_not eq(true)
      end

      it "requires user_birthday" do
        subject.user_birthday = nil
        subject.valid?.should_not eq(true)
      end

      it "requires security_code" do
        subject.security_code = nil
        subject.valid?.should_not eq(true)
      end

      it "requires expiration_date" do
        subject.expiration_date = nil
        subject.valid?.should_not eq(true)
      end

      it "requires user_identification" do
        subject.user_identification = nil
        subject.valid?.should_not eq(true)
      end

      it "requires telephone" do
        subject.telephone = nil
        subject.valid?.should_not eq(true)
      end
    end

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

  it "should return true for payment" do
    payment = FactoryGirl.build(:payment, :payment_type => Payment::TYPE[:credit])
    payment.paid_with_credit_card?.should == true
  end
end
