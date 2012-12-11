require "spec_helper"

describe DiscountExpirationCheckService do
  before :each do
    User.destroy_all
    CampaignEmail.destroy_all
  end

	# Used in purchases_amount_strategy, in cart_service
	context ".discount_expired?" do

		context "user converted from campaign email" do
			let(:converted_user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - Setting.discount_period_in_days.to_i.days - 1) }

			context "8 days after original campaign email's creation date" do
				it "returns true" do
          DiscountExpirationCheckService.stub(:lower_limit_expiration_date) {DateTime.parse("2007-12-12").to_date}
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:converted_user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i).days) }

				it "returns false" do
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_false
				end
			end

      context "within the expiration date (due to the lower_limit_expiration_date)" do
        let(:converted_user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - 1.year) }

        it "returns false" do
          DiscountExpirationCheckService.stub(:lower_limit_expiration_date) {(DateTime.now + 3.days).to_date}
          DiscountExpirationCheckService.discount_expired?(converted_user).should be_false
        end
      end
		end

		context "user not created from a campaign email" do
			let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - Setting.discount_period_in_days.to_i.days - 1) }

			context "8 days after original campaign email's creation date" do
				it "returns true" do
          DiscountExpirationCheckService.stub(:lower_limit_expiration_date) {DateTime.parse("2007-12-12").to_date}
					DiscountExpirationCheckService.discount_expired?(user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i).days) }

				it "returns false" do
					DiscountExpirationCheckService.discount_expired?(user).should be_false
				end
			end
		end

	end

	# Used in notification worker every day
	context ".discount_expires_in_48_hours?" do
    context "user converted from campaign email" do

      context "before 48hs warning" do
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i - 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_false
        end
      end

      context "after 48hs warning" do
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i + 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_false
        end
      end

      context "within 48hs warning" do
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i).days) }

        it "returns true" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_true
        end
      end
    end

    context "campaign email" do

      context "before 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i - 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(campaign_email).should be_false
        end
      end

      context "after 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i + 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(campaign_email).should be_false
        end
      end

      context "within 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days.to_i - Setting.discount_period_expiration_warning_in_days.to_i).days) }

        it "returns true" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(campaign_email).should be_true
        end
      end
    end
	end

  context ".discount_expires_at" do
    let(:now) { DateTime.now }
    let(:user) { FactoryGirl.create(:user, created_at: now) }

    it "returns the expiration date for a given user" do
      DiscountExpirationCheckService.discount_expiration_date_for(user).should eq((now + Setting.discount_period_in_days.to_i.days).to_date)
    end
  end

  describe ".discount_expiration_48_hours_emails_list" do
    context "returns a list of emails with expiration discount" do
      let!(:user) { FactoryGirl.create(:user, created_at: DateTime.now - DiscountExpirationCheckService.days_until_warning.days ) }
      let!(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - DiscountExpirationCheckService.days_until_warning.days ) }
      it "returns a list of emails" do
        described_class.discount_expiration_48_hours_emails_list.should eq([user.email, campaign_email.email])
      end

      it "returns a empty list" do
        user.created_at = DateTime.now - 6.days
        user.save

        campaign_email.created_at = DateTime.now
        campaign_email.save

        described_class.discount_expiration_48_hours_emails_list.should eq([])
      end


    end
  end
end
