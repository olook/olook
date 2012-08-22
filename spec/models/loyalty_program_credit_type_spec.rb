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
        after do
          Delorean.back_to_the_present
        end

        it "should remove credits when credits is equal to debit" do
          loyalty_program_credit_type.add(amount,user_credit,order)
          Delorean.jump 1.month
          expect{
            loyalty_program_credit_type.remove(amount,user_credit,order)
          }.to change{ Credit.count }.by(1)
          loyalty_program_credit_type.total(user_credit, DateTime.now).should == 0.0
        end

        it "should remove credits when there's more than 1 credit" do
          3.times { loyalty_program_credit_type.add(amount,user_credit,order) }

          Delorean.jump 1.month

          expect{
            loyalty_program_credit_type.remove(BigDecimal.new("99"),user_credit,order)
          }.to change{ Credit.count }.by(4)

          loyalty_program_credit_type.total(user_credit, DateTime.now).should == 0.99
        end

        it "should remove credits when credits is greater than debits" do
          loyalty_program_credit_type.add(amount,user_credit,order)
          Delorean.jump 1.month
          expect{
            loyalty_program_credit_type.remove(BigDecimal.new("31.33"),user_credit,order)
          }.to change{ Credit.count }.by(2)
          
          loyalty_program_credit_type.total(user_credit, DateTime.now).should == 2.0
        end
      end

      context "when user hasn't got enough credits" do
        it "should not remove credits and should return false" do
          loyalty_program_credit_type.add(amount,user_credit,order)

          loyalty_program_credit_type.add(amount,user_credit,order)

          Delorean.jump 1.month

          loyalty_program_credit_type.remove(amount * 2,user_credit,order)

          loyalty_program_credit_type.remove(amount,user_credit,order).should == false

          Delorean.back_to_the_present

          loyalty_program_credit_type.remove(amount,user_credit,order).should == false

          loyalty_program_credit_type.total(user_credit, DateTime.now + 1.month).should == 0.0
        end
      end      
    end

  end
end
