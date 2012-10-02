# -*- encoding : utf-8 -*-
require "spec_helper"

describe LoyaltyPresenter do
  let(:user) {FactoryGirl.create(:user)}

  context "User has credits for current month" do 
    let(:user_credit) { double(:total => BigDecimal.new("9.99"))}

    it "should have credits for current month" do
      presenter = LoyaltyPresenter.new(user, user_credit)
      presenter.has_loyalty_credits_for_current_month?.should be_true
    end

    it "should have no credits when user is nil" do
      presenter = LoyaltyPresenter.new(nil, user_credit)
      presenter.has_loyalty_credits_for_current_month?.should be_false
    end
    
    it "should return the total amount of loyalty_credits for current month" do
      presenter = LoyaltyPresenter.new(user, user_credit)
      presenter.loyalty_credits_for_current_month.should == BigDecimal.new("9.99")
    end
  end

  context "User doesn't have credits for current month" do 
    let(:user_credit) { double(:total => BigDecimal.new("0.00"))}

    it "should return false" do
      presenter = LoyaltyPresenter.new(nil, user_credit)
      presenter.has_loyalty_credits_for_current_month?.should be_false
    end
  end

  context "User_credits is nil" do
  
    let(:presenter) { LoyaltyPresenter.new(user, nil) }

    it "should have no credits for current month" do
      presenter.has_loyalty_credits_for_current_month?.should be_false
    end

    it "should have no credits for next month" do
      presenter.has_loyalty_credits_for_next_month?.should be_false
    end

  end



end
