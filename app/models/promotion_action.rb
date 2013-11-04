# encoding: utf-8
class PromotionAction < ActiveRecord::Base
  validates :type, presence: true
  has_many :action_parameters

  class << self
    attr_accessor :filters
  end

  @filters = {
    param: {desc: 'Parâmetro da Ação', kind: 'string'},
    brand: {desc: 'Marca do produto a ser descontado', kind: 'string'},
    full_price: {desc: 'Produto a ser descontado não pode ter markdown', kind: 'boolean' }
  }

  def self.filters
    @filters ||= PromotionAction.filters.dup
  end

  def apply(cart, param, match)
    calculate(cart.items, param).each do |item|
      adjustment = item[:adjustment]
      item = cart.items.find(item[:id])
      item.cart_item_adjustment.update_attributes(value: adjustment, source: match.name) if item.should_apply?(adjustment)
    end
  end

  def simulate(cart, param)
    cart.items.any? ? calculate(cart.items, param).map{|item| item[:adjustment]}.reduce(:+) : 0
  end

  def simulate_for_product(product, cart, param)
    if cart.items.any?
      _calc = calculate(cart.items, param)
      _c = _calc.find { |item| item[:product_id] == product.id }
      return _c ? _c[:adjustment] : 0
    end
    0
  end

  protected
    #
    # This method should return an Array of Hashes in the form:
    # => [{id: item.id, adjustment: item.price}]
    #
    def calculate(cart, param); end
end
