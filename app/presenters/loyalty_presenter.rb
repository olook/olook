# -*- encoding : utf-8 -*-
class LoyaltyPresenter

  def initialize(user, user_credits)
    @user = user
    @user_credits = user_credits
  end

  def has_loyalty_credits_for_current_month?
    total = loyalty_credits_for()
    total > 0
  end

  def has_loyalty_credits_for_next_month?
    total = loyalty_credits_for(1.month.since.at_beginning_of_month) 
    total > 0
  end

  def loyalty_credits_for_current_month
    loyalty_credits_for
  end

  def loyalty_credits_for_next_month
    loyalty_credits_for 1.month.since.at_beginning_of_month
  end

  private 
   
   def loyalty_credits_for(month=nil)
    return 0 if @user_credits.nil? || @user.nil?

    month.nil? ? @user_credits.total : @user_credits.total(month)
   end

end