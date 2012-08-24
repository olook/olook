# encoding: utf-8
class RedeemCreditType < CreditType
  include CreditsBuilderHelper
  
  def add(opts={})
    raise ArgumentError.new('Admin user is required!') if opts[:admin_id].nil?
    user_credit = opts.delete(:user_credit)
    user_credit.credits.create!(opts)
  end

  def remove(opts={})
    raise ArgumentError.new('Admin user is required!') if opts[:admin_id].nil?
    user_credit, amount = opts.delete(:user_credit), opts.delete(:value)
    
    default_attrs = {:admin_id => opts[:admin_id].try(:to_i)}

    if user_credit.total >= amount
      build_debits(selected_credits(amount,user_credit), amount)
    else
      false
    end
  end
end