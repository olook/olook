class DiscountExpirationCheckService

	class << self 
		def discount_expired?(user)
			raise ArgumentError.new('a user is required!') unless user

			sign_up_date(user).to_date <= 7.days.ago.to_date
		end

		def discount_expires_in_48_hours?(user_or_campaign_email)
			sign_up_date(user_or_campaign_email).to_date == 5.days.ago.to_date
		end

		private

			def sign_up_date(user_or_campaign_email)
				(user_or_campaign_email.respond_to?(:campaign_email_created_at) && user_or_campaign_email.campaign_email_created_at) ? user_or_campaign_email.campaign_email_created_at : user_or_campaign_email.created_at
			end
	end

end
