# encoding: utf-8
class InviteCreditType < CreditType

  def remove(opts)
    user_credit, amount = opts.delete(:user_credit), opts[:value]

    if user_credit.total >= amount
      user_credit.credits.create!(opts.merge({
        :is_debit => true
      }))
    else
      false
    end
  end

  def add(opts)
    user_credit = opts.delete(:user_credit)
    user_credit.credits.create!(opts)
  end
end