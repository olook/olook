class PromotionAction < ActiveRecord::Base
  validates :type, presence: true
  has_many :action_parameters
  has_many :promotions, through: :action_parameters

  def apply(cart, param, promotion)
    cart.update_attributes(coupon_code: nil) if cart.coupon
    calculate(cart.items, param).each do |item|
      adjustment = item[:adjustment]
      item = cart.items.find(item[:id])
      item.cart_item_adjustment.update_attributes(value: adjustment, source: promotion.name) if item.should_apply?(adjustment)
    end
  end

  def simulate(cart, param)
    cart.items.any? ? calculate(cart.items, param).map{|item| item[:adjustment]}.reduce(:+) : 0
  end

  def simulate_for_product(product,param)
    product ? calculate_product(product, param) : 0
  end

  protected
    #
    # This method should return an Array of Hashes in the form:
    # => [{id: item.id, adjustment: item.price}]
    #
    def calculate(cart, param); end
    def calculate_product(product,param); end
end
