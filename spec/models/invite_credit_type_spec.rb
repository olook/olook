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
          invite_credit_type.add(amount,user_credit,order)
          invite_credit_type.total(user_credit, DateTime.now).should == amount
        end
      end
    end

    describe "removing credits" do

      context "when user has enough credits" do
        it "should remove credits" do
          invite_credit_type.add(amount,user_credit,order)
          invite_credit_type.remove(amount,user_credit,order)

          invite_credit_type.total(user_credit, DateTime.now).should == 0.0
        end
      end

      context "when user hasn't got enough credits" do
        it "should not remove credits and should return false" do
          invite_credit_type.remove(amount,user_credit,order).should == false

          invite_credit_type.total(user_credit, DateTime.now).should == 0.0
        end
      end      
    end

  end

end
