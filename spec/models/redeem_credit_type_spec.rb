require 'spec_helper'

describe RedeemCreditType do

  describe "credit operations" do
    let(:user) { FactoryGirl.create(:user) }
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:redeem_credit_type) {FactoryGirl.create(:redeem_credit_type, :code => :redeem)}
    let!(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => redeem_credit_type)}
    let(:amount) { BigDecimal.new("33.33") }
    
    let(:attrs_for_credit) do
      {amount: amount,
      user: user,
      admin_id: user.id,
      order: order}
    end    

    describe "adding credits" do
      context "when user recieves a credit" do
        it "should add credits" do
          user.user_credits_for(:redeem).add(attrs_for_credit)
          subject.total(user.user_credits_for(:redeem)).should == amount
        end
      end
    end

    describe "removing credits" do
      
      context "when user hasn't enough credits" do
        it "should not remove" do
          user.user_credits_for(:redeem).remove(attrs_for_credit).should be_false
          user.user_credits_for(:redeem).total.should == 0.0
        end
      end

      context "when user has enough credits" do
        
        it "should remove credits when credits is equal to debit" do
          user.user_credits_for(:redeem).add(attrs_for_credit.dup)

          expect{
            user.user_credits_for(:redeem).remove(attrs_for_credit)
          }.to change{ Credit.count }.by(1)
          subject.total(user.user_credits_for(:redeem)).should == 0.0
        end

        it "should remove credits when there's more than 1 credit" do
          3.times { user.user_credits_for(:redeem).add(attrs_for_credit.dup) }

          expect{
            user.user_credits_for(:redeem).remove(attrs_for_credit.merge(:amount => BigDecimal.new('99')))
          }.to change{ Credit.count }.by(1)

          subject.total(user.user_credits_for(:redeem)).should == 0.99
        end

        it "should remove credits when credits is greater than debits" do
          user.user_credits_for(:redeem).add(attrs_for_credit.dup)

          expect{
            user.user_credits_for(:redeem).remove(attrs_for_credit.merge(:amount => BigDecimal.new('31.33')))
          }.to change{ Credit.count }.by(1)
          
          subject.total(user.user_credits_for(:redeem)).should == 2.0
        end
      end
    end
  end
end
