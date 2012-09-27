class CreditType < ActiveRecord::Base
  attr_accessor :type
  has_many :user_credits
  has_many :credit_payments

  CREDIT_CODES = {invite: 'MGM', loyalty_program: 'Fidelidade', redeem: 'Reembolso'}

  def total(user_credit, date = DateTime.now, kind = :available, source=nil)
    positive = credit_sum(user_credit, date, 0, kind, source)
    negative = credit_sum(user_credit, date, 1, kind, source)
    total = (positive - negative)
  end

  #NOTICE: FOR ALL NORMAL CREDITS DOESN'T HAVE HOLDING
  def credit_sum(user_credit, date, is_debit, kind, source=nil)
    if (kind == :holding)
      0
    else
      if source.nil?
        user_credit.credits.where("is_debit = ?", is_debit).sum(:value)
      else
        user_credit.credits.where("is_debit = ? and source = ?", is_debit, source).sum(:value)
      end
    end
  end
  
  def add(opts={})
    user_credit = opts.delete(:user_credit)
    user_credit.credits.create!(opts)
  end

  def remove(opts={})
    user_credit, amount = opts.delete(:user_credit), opts[:value]
    
    if user_credit.total >= amount
      [user_credit.credits.create!(opts.merge({
        :is_debit => true
      }))]
    else
      false
    end
  end
end
