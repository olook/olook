require 'spec_helper'

describe LoyaltyProgramCreditType do
  let(:user) { FactoryGirl.create(:member) }

  let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => loyalty_program_credit_type) }

  describe "credit operations" do
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:amount) { BigDecimal.new("33.33") }

    describe "adding credits" do
      context "when user creates a credit" do
        it "should add credits" do
          loyalty_program_credit_type.add(amount,user_credit,order)
          loyalty_program_credit_type.total(user_credit, DateTime.now + 1.month).should == amount
        end
      end
    end

    describe "removing credits" do

      context "when user has enough credits" do
        xit "should remove credits" do
          loyalty_program_credit_type.add(amount,user_credit,order)
          loyalty_program_credit_type.remove(amount,user_credit,order)

          loyalty_program_credit_type.total(user_credit, DateTime.now + 1.month).should == 0.0
        end
      end

      context "when user hasn't got enough credits" do
        xit "should not remove credits and should return false" do
          loyalty_program_credit_type.remove(amount,user_credit,order).should == false

          loyalty_program_credit_type.total(user_credit, DateTime.now + 1.month).should == 0.0
        end
      end      
    end

  end
end
