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

    def find_all_discounts
      initial_date = DateTime.now - 1.month
      period = 1.month
      discount_period = Setting.discount_period_in_days.days
              
      users = User.where({created_at: ((initial_date).beginning_of_day..(initial_date + period).end_of_day)}).map do |user|
                start_date = user.campaign_email_created_at ? user.campaign_email_created_at : user.created_at
                OpenStruct.new(email: user.email, name: user.name, discount_start: start_date.beginning_of_day, discount_end: (start_date + discount_period).end_of_day, used_discount: (user.orders.purchased.size > 0))
              end

      campaign_emails = CampaignEmail.where({created_at: ((initial_date).beginning_of_day..(initial_date + period).end_of_day)}).map do |campaign_email|                
                OpenStruct.new(email: campaign_email.email, name: nil, discount_start: campaign_email.created_at.beginning_of_day, discount_end: (campaign_email.created_at + discount_period).end_of_day, used_discount: false)
              end

      users + campaign_emails
    end

    private

    def sign_up_date(user_or_campaign_email)
      (user_or_campaign_email.respond_to?(:campaign_email_created_at) && user_or_campaign_email.campaign_email_created_at) ? user_or_campaign_email.campaign_email_created_at : user_or_campaign_email.created_at
    end
  end

end
