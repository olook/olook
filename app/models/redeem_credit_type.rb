# encoding: utf-8
class RedeemCreditType < CreditType

  def add(opts={})
    raise ArgumentError.new('Admin user is required!') if opts[:admin_id].nil?
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