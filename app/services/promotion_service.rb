# this class is responsible to
class PromotionService
  attr_reader :user
  attr_accessor :promotions, :order

  def self.by_product product
    promotion = Promotion.purchases_amount
    ((100 - promotion.discount_percent) * product.price) / 100
  end

  def initialize(user=nil, order=nil)
    @user = user
    @promotions = ::Promotion.active.order(:priority)
    @order = order
  end

  def detect_current_promotion(cart=nil)
    promo = nil
    promotions.each do |promotion|
      if satisfies_criteria?({cart: cart, promotion: promotion})
        promo = promotion
        break
      end
    end
    promo
  end

  def satisfies_criteria?(opts={})
    cart = opts[:cart]
    promotion = opts[:promotion]

    return unless promotion

    strategy = promotion.load_strategy(promotion, user)
    strategy.matches?(cart)
  end
end
