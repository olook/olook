require "spec_helper"

describe DiscountExpirationCheckService do
  before :each do
    User.destroy_all
    CampaignEmail.destroy_all
  end

	# Used in purchases_amount_strategy, in cart_service
	context ".discount_expired?" do

		context "user converted from campaign email" do
			let(:converted_user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - Setting.discount_period_in_days.days) }

			context "7 days after original campaign email's creation date" do
				it "returns true" do
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:converted_user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days).days) }

				it "returns false" do
					DiscountExpirationCheckService.discount_expired?(converted_user).should be_false
				end
			end
		end

		context "user not created from a campaign email" do
			let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - Setting.discount_period_in_days.days) }

			context "7 days after original campaign email's creation date" do
				it "returns true" do
					DiscountExpirationCheckService.discount_expired?(user).should be_true
				end
			end

			context "within 7 days of expiration date" do
				let(:user) { FactoryGirl.create(:user, created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days).days) }

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
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days - 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_false
        end
      end

      context "after 48hs warning" do
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days + 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_false
        end
      end

      context "within 48hs warning" do
        let(:user) { FactoryGirl.create(:user, campaign_email_created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days).days) }

        it "returns true" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(user).should be_true
        end
      end
    end

    context "campaign email" do

      context "before 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days - 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(campaign_email).should be_false
        end
      end

      context "after 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days + 1).days) }
        it "returns false" do
          DiscountExpirationCheckService.discount_expires_in_48_hours?(campaign_email).should be_false
        end
      end

      context "within 48hs warning" do
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days).days) }

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
      DiscountExpirationCheckService.discount_expiration_date_for(user).should eq((now + Setting.discount_period_in_days.days).to_date)
    end
  end

  describe ".discount_expiration_48_hours_emails_list" do
    context "returns a list of emails with expiration discount" do
      let!(:user) { FactoryGirl.create(:user, created_at: DateTime.now - 5.days ) }
      let!(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now - 5.days ) }
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

  context ".find_all_discounts" do

    context "in the period" do
      context "unused discount" do

        let(:now) { DateTime.now }
        let(:user) { FactoryGirl.create(:member, created_at: now) }
        let(:campaign_email) { FactoryGirl.create(:campaign_email, created_at: DateTime.now) }

        context "user without a campaign_email" do
          it "returns a list containing the created user" do
            user.save
            discount_start = (user.campaign_email_created_at ? user.campaign_email_created_at : user.created_at)
            discount_period = Setting.discount_period_in_days.days
            DiscountExpirationCheckService.find_all_discounts.first.to_json.should eq(OpenStruct.new(email: user.email, name: "First Name Last Name", discount_start: discount_start.beginning_of_day, discount_end: (discount_start + discount_period).end_of_day, used_discount:false).to_json)
            user.destroy
          end

          it "returns a list containing only one user" do
            user.save
            DiscountExpirationCheckService.find_all_discounts.size.should eq(1)
            user.destroy
          end          
        end

        context "campaign_email without user" do
          it "returns a list containing the created user" do            
            campaign_email.save
            discount_period = Setting.discount_period_in_days.days
            DiscountExpirationCheckService.find_all_discounts.first.to_json.should eq(OpenStruct.new(email: "eu@teste.com", name: nil, discount_start: campaign_email.created_at.beginning_of_day, discount_end: (campaign_email.created_at + discount_period).end_of_day, used_discount:false).to_json)
            campaign_email.destroy
          end

          it "returns a list containing only one user" do
            campaign_email.save
            DiscountExpirationCheckService.find_all_discounts.size.should eq(1)
            campaign_email.destroy
          end            
        end
      end

      context "used discount" do
        let!(:order) {FactoryGirl.create(:delivered_order)}
        context "user with a purchased order" do
          it "returns a list containing the created user" do
            user = order.user
            discount_start = (user.campaign_email_created_at ? user.campaign_email_created_at : user.created_at)
            discount_period = Setting.discount_period_in_days.days
            DiscountExpirationCheckService.find_all_discounts.first.to_json.should eq(OpenStruct.new(email: user.email, name: "User First Name User Last Name", discount_start: discount_start.beginning_of_day, discount_end: (discount_start + discount_period).end_of_day, used_discount:true).to_json)
          end
        end
      end
    end

    context "out of the period" do
      let(:now) { DateTime.now }
      let!(:order) {FactoryGirl.create(:delivered_order, created_at: now - 3.months)}

      it "returns an empty list" do
        order.user.update_attribute(:created_at, now - 3.months)
        User.all.size.should eq(1)
        DiscountExpirationCheckService.find_all_discounts.should be_empty
      end
    end

  end

end
