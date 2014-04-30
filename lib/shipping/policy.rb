class Shipping::Policy
  attr_accessor :zip, :amount
  def initialize(zip=nil, amount=nil)
    @zip = zip
    @amount = amount
  end

  def free_shipping?
    return true if has_params? && has_free_shipping?
  end

  private

  def has_free_shipping?
    ship = ShippingPolicy.zip_code_between(zip).first
    ship && amount_bigger_than_current_shipping?(ship)
  end

  def amount_bigger_than_current_shipping? shipping_policy
    amount.to_d >= shipping_policy.free_shipping.to_d
  end

  def has_params?
    zip && amount
  end
end
