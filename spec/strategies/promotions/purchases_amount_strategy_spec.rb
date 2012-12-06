require 'spec_helper'

describe Promotions::PurchasesAmountStrategy do
	context "#matches?" do
		let(:promo) { FactoryGirl.create(:first_time_buyers) }

		context "user doesn't have any purchases and discount is still active" do
			let(:user) { FactoryGirl.create(:user) }

		  it "returns true" do
		    Promotions::PurchasesAmountStrategy.new(promo.param, user).matches?.should be_true
		  end
		end

		context "user doesn't have any purchases but discount is expired" do

			context "regular user" do
				let(:user) { FactoryGirl.create(:user, created_at: Setting.discount_period_in_days.days.ago) }

				it "returns false" do
					Promotions::PurchasesAmountStrategy.new(promo.param, user).matches?.should be_false
				end
			end				
			
			context "converted user" do
				let(:user) { FactoryGirl.create(:user, campaign_email_created_at: Setting.discount_period_in_days.days.ago) }
			
				it "returns false" do
					Promotions::PurchasesAmountStrategy.new(promo.param, user).matches?.should be_false
				end
			end 
		end

		context "user has a purchase" do
			let(:user_with_a_purchase) { FactoryGirl.create(:delivered_order).user }

		  it "returns false" do
		    Promotions::PurchasesAmountStrategy.new(promo.param, user_with_a_purchase).matches?.should be_false
		  end
		end

	end
end
