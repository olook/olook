# encoding: utf-8
class RedeemCreditType < CreditType
  
  def add(opts={})
    raise ArgumentError.new('Admin user is required!') if opts[:admin_id].nil?
    super(opts)
  end
  
end