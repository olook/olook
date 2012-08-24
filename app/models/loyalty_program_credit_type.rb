# encoding: utf-8
class LoyaltyProgramCreditType < CreditType

  PERCENTAGE_ON_ORDER = 0.20

  include CreditsBuilderHelper
  
  def credit_sum(user_credit, date, is_debit)
  	user_credits(user_credit, date, is_debit).sum(:value)
  end

  #TODO: create a mechanism that nullifies the available credits until the debit is paid
  def remove(opts)
    user_credit, amount, order = opts.delete(:user_credit), opts.delete(:value), opts.delete(:order)

    if user_credit.total >= amount
      build_debits(selected_credits(amount,user_credit), amount)
    else
      false
    end
  end

  def add(opts)
    user_credit = opts.delete(:user_credit)
    user_credit.credits.create!(opts.merge({
      :activates_at => period_start, 
      :expires_at => period_end,
    }))
  end

  private

    def period_start(date = DateTime.now)
      date += 1.month
      date.at_beginning_of_month
    end

    def period_end(date = DateTime.now)
      date += 2.months
      date.at_end_of_month
    end

    def user_credits(user_credit, date, is_debit)
      user_credit.credits.where("activates_at <= ? AND expires_at >= ? AND is_debit = ?", date, date, is_debit).order('expires_at desc')
    end

end
