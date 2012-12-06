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
      user_list = User.with_discount_about_to_expire_in_48_hours
      user_list << CampaignEmail.with_discount_about_to_expire_in_48_hours
      user_list.flatten
    end

    def find_all_discounts
      find_users_with_discount(Setting.discount_period_in_days.days) + find_campaign_emails_with_discount(Setting.discount_period_in_days.days)
    end

    private

    def find_campaign_emails_with_discount(discount_period)      
      CampaignEmail.where({created_at: ((DateTime.now - 1.month).beginning_of_day..(DateTime.now).end_of_day)}).map do |campaign_email|                
        OpenStruct.new(email: campaign_email.email, name: nil, discount_start: campaign_email.created_at.beginning_of_day, discount_end: (campaign_email.created_at + discount_period).end_of_day, used_discount: false)
      end
    end

    def find_users_with_discount(discount_period)      
      User.where({created_at: ((DateTime.now - 1.month).beginning_of_day..(DateTime.now).end_of_day)}).includes(:orders).map do |user|
        start_date = user.campaign_email_created_at ? user.campaign_email_created_at : user.created_at
        used_discount = user.orders.purchased.empty? ? false : user.orders.purchased.first.created_at < (start_date + discount_period) 
        OpenStruct.new(email: user.email, name: user.name, discount_start: start_date.beginning_of_day, discount_end: (start_date + discount_period).end_of_day, used_discount: used_discount)
      end      
    end

    def sign_up_date(user_or_campaign_email)
      (user_or_campaign_email.respond_to?(:campaign_email_created_at) && user_or_campaign_email.campaign_email_created_at) ? user_or_campaign_email.campaign_email_created_at : user_or_campaign_email.created_at
    end
  end

end
