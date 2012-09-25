# -*- encoding : utf-8 -*-
class LoyaltyPresenter

	def initialize(user, user_credits)
		@user = user
		@user_credits = user_credits
	end

	def has_loyalty_credits_for_current_month?
		total = @user_credits.total
		@user.present? && total > 0
	end

	def has_loyalty_credits_for_next_month?
		total = @user_credits.total(1.month.since.at_beginning_of_month)
		@user.present? && total > 0
	end

	def loyalty_credits_for_current_month
		@user_credits.total
	end

	def loyalty_credits_for_next_month
		@user_credits.total(1.month.since.at_beginning_of_month)
	end
end