require 'spec_helper'

describe InviteCreditType do
  let(:user) { FactoryGirl.create(:member) }

  let(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => invite_credit_type) }

  describe "credit operations" do
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:amount) { BigDecimal.new("33.33") }

    describe "adding credits" do
      context "when user creates a credit" do
        it "should add credits" do
          user_credit.add(amount,order)
          user_credit.total.should == amount
        end
      end
    end

    describe "removing credits" do

      context "when user has enough credits" do
        it "should remove credits" do
          user_credit.add(amount,order)
          user_credit.remove(amount,order)

          user_credit.total.should == 0.0
        end
      end

      context "when user hasn't got enough credits" do
        it "should not remove credits and should return false" do
          user_credit.remove(amount,order).should == false

          user_credit.total.should == 0.0
        end
      end      
    end

  end

end
