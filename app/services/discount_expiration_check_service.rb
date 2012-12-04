class DiscountExpirationCheckService

	class << self 
		def discount_expired?(user)
			raise ArgumentError.new('a user is required!') unless user

			sign_up_date(user).to_date <= 7.days.ago.to_date
		end

		def discount_expires_in_48_hours?(user)
			sign_up_date(user).to_date == 5.days.ago.to_date
		end

		private

			def sign_up_date(user)
				user.converted_at? ? user.converted_at : user.created_at
			end
	end

end
