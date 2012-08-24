require 'spec_helper'

describe InviteCreditType do
  let(:user) { FactoryGirl.create(:member) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }

  describe "credit operations" do
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:amount) { BigDecimal.new("33.33") }
    let(:credit_parmas) {{:amount =>  amount, :order => order, :user => user}}

    describe "adding credits" do
      context "when user creates a credit" do
        it "should add credits" do
          user.user_credits_for(:invite).add(credit_parmas.dup)
          user.user_credits_for(:invite).total(DateTime.now).should == amount
        end
      end
    end

    describe "removing credits" do

      context "when user has enough credits" do
        it "should remove credits" do
          user.user_credits_for(:invite).add(credit_parmas.dup)
          user.user_credits_for(:invite).remove(credit_parmas)

          user.user_credits_for(:invite).total(DateTime.now).should == 0.0
        end
      end

      context "when user hasn't got enough credits" do
        it "should not remove credits and should return false" do
          user.user_credits_for(:invite).remove(credit_parmas).should be_false
          user.user_credits_for(:invite).total(DateTime.now).should == 0.0
        end
      end      
    end

  end

end
