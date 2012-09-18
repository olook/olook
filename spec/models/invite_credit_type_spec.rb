require 'spec_helper'

describe InviteCreditType do
  let(:user) { FactoryGirl.create(:member) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }
  let(:order) {FactoryGirl.create(:order, :user => user)}
  let(:amount) { BigDecimal.new("33.33") }

  describe "credit operations" do
    
    let(:credit_parmas) {{:amount =>  amount, :order => order}}

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

  describe "::amount_of_inviter_bonus_credits" do
    let(:credit_parmas) {{:amount =>  amount, :order => order, :source => :invitee_bonus}}

    it "should return the amount of inviter" do
      user.user_credits_for(:invite).add(credit_parmas.dup)
      user.user_credits_for(:invite).remove(credit_parmas.merge(:amount => 3.33))
      described_class.amount_of_inviter_bonus_credits(user.user_credits_for(:invite)).should eq(30.0)
    end
  end

  describe "::amount_of_invitee_bonus_credits" do
    let(:credit_parmas) {{:amount =>  amount, :order => order, :source => :inviter_bonus}}

    it "should return the amount of invitee" do
      user.user_credits_for(:invite).add(credit_parmas.dup)
      user.user_credits_for(:invite).remove(credit_parmas.merge(:amount => 3.33))
      described_class.amount_of_invitee_bonus_credits(user.user_credits_for(:invite)).should eq(30.0)
    end
  end

  describe "::quantity_of_inviter_bonus_credits" do
    let(:credit_parmas) {{:amount =>  amount, :order => order, :source => :invitee_bonus}}

    it "should return the quantity of converted invites" do
      4.times{user.user_credits_for(:invite).add(credit_parmas.dup)}
      described_class.quantity_of_inviter_bonus_credits(user.user_credits_for(:invite)).should eq(4)
    end
  end
end
