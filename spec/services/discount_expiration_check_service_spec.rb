require "spec_helper"

describe DiscountExpirationCheckService do

	# Used in purchases_amount_strategy, in cart_service
	context ".discount_expired?" do 
		
		context "user converted from campaign email" do
			let(:converted_user) { FactoryGirl.create(:user, converted_at: DateTime.now - 7.days) }

			context "7 days after original campaign email's creation date" do
				it "returns true" do
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:converted_user) { FactoryGirl.create(:user, converted_at: DateTime.now - 5.days) }

				it "returns false" do
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_false
				end
			end
		end

		context "user not created from a campaign email" do
			let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - 7.days) }

			context "7 days after original campaign email's creation date" do
				it "returns true" do
					DiscountExpirationCheckService.discount_expired?(user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - 5.days) }

				it "returns false" do
					DiscountExpirationCheckService.discount_expired?(user).should be_false
				end
			end
		end		

	end

	# Used in notification worker every day
	context ".discount_expires_in_48_hours?" do
	end
end