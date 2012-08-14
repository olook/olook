class LoyaltyProgramCreditType < CreditType
  
  def credit_sum(user_credit, date, is_debit)
  	user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?", date, date, is_debit).sum(:value)
  end

end
