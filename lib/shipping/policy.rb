class Shipping::Policy
  attr_accessor :zip, :amount
  def initialize(zip=nil, amount=nil)
    @zip = zip
    @amount = amount
  end

  def free_shipping?
    return false unless zip || amount
    return false if seek_policy.blank?
    true
  end

  def seek_policy
    ShippingPolicy.zip_code_between(zip).with_amount(amount)
  end
end
