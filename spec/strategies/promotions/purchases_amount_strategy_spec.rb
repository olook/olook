require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
	context "#matches?" do

		context "user doesn't have any purchases and discount is still active" do
		  it "returns true" do
		  	pending("check for discount")
		    promo = FactoryGirl.create(:first_time_buyers)
		    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:user)).matches?.should be_true
		  end
		end

		context "user doesn't have any purchases but discount is expired" do
			it "returns false" do
				pending("to implement")
			end
		end

		context "user has a purchase" do
		  it "returns false" do
		    promo = FactoryGirl.create(:first_time_buyers)
		    Promotions::PurchasesAmountStrategy.new(promo.param, FactoryGirl.create(:delivered_order).user).matches?.should be_false
		  end
		end 

	end
end
