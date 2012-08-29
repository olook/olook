class CreditType < ActiveRecord::Base
  attr_accessor :type
  has_many :user_credits
  has_many :credit_payments

  CREDIT_CODES = {invite: 'MGM', loyalty_program: 'Fidelidade', redeem: 'Reembolso'}

  def total(user_credit, date = DateTime.now)
    positive = credit_sum(user_credit, date, 0)
    negative = credit_sum(user_credit, date, 1)
    positive - negative
  end

  def credit_sum(user_credit, date, is_debit)
  	user_credit.credits.where("is_debit = ?", is_debit).sum(:value)
  end

end
