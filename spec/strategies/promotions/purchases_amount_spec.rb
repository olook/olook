require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
	context "#matches?" do
	  it "should return true if user doesn't have any purchases" do
	    promo = FactoryGirl.create(:first_time_buyers)
	    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:user)).matches?.should be_true
	  end

	  it "should return false if the user has any purchases" do
	    promo = FactoryGirl.create(:first_time_buyers)
	    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:delivered_order).user).matches?.should be_false
	  end

	  context "promotion expiration" do
		  it "should return true if the promotion is still active" do
		  	
		  end

		  it "should return false if promotion has expired" do

		  end
	  end
	end
end
