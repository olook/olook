class DiscountExpirationCheckService

  class << self
    def discount_expired?(user)
      raise ArgumentError.new('a user is required!') unless user

			sign_up_date(user).to_date <= Setting.discount_period_in_days.days.ago.to_date
		end

		def discount_expires_in_48_hours?(user_or_campaign_email)
			sign_up_date(user_or_campaign_email).to_date == (Setting.discount_period_in_days - Setting.discount_period_expiration_warning_in_days).days.ago.to_date
		end

		def discount_expiration_date_for(user_or_campaign_email)
			(sign_up_date(user_or_campaign_email) + Setting.discount_period_in_days.days).to_date
		end

    def discount_expiration_48_hours_emails_list
      user_list = User.with_discount_about_to_expire_in_48_hours + CampaignEmail.with_discount_about_to_expire_in_48_hours
    end

    private

    def sign_up_date(user_or_campaign_email)
      (user_or_campaign_email.respond_to?(:campaign_email_created_at) && user_or_campaign_email.campaign_email_created_at) ? user_or_campaign_email.campaign_email_created_at : user_or_campaign_email.created_at
    end
  end

end
