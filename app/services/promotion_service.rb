# this class is responsible to
class PromotionService
  attr_reader :user
  attr_accessor :promotions, :order

  def self.by_product product
    promotion = Promotion.purchases_amount
    ((100 - promotion.discount_percent) * product.price) / 100
  end

  def self.apply_discount_for_price promotion, price
    PromotionService.new.apply_discount_for(promotion, price)
  end

  def self.apply_discount_for_product promotion, product
    PromotionService.new.apply_discount_for(promotion, product.retail_price)
  end

  def self.user_applies_for_this_promotion? user, promotion
    PromotionService.new(user).satisfies_criteria? promotion
  end

  def initialize(user=nil, order=nil)
    @user = user
    @promotions = ::Promotion.active.order(:priority)
    @order = order
  end

  def detect_current_promotion
    promo = nil
    promotions.each do |promotion|
      if satisfies_criteria? promotion
        promo = promotion
        break
      end
    end
    promo
  end

  def apply_discount promotion
    apply_discount_for promotion, order.subtotal
  end

  def apply_discount_for promotion, value
    (promotion.discount_percent * value) / 100
  end

  def satisfies_criteria? promotion
    return unless promotion
    strategy = promotion.load_strategy.new(promotion.param, user)
    strategy.matches?
  end
end
