# this class is responsible to
class PromotionService
  attr_reader :user
  attr_accessor :promotions, :order

  def initialize(user, order=nil)
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
    (promotion.discount_percent * order.line_items_total) / 100
  end

  def apply_promotion
    unless order.used_coupon
      promotion = detect_current_promotion
      order.create_used_promotion(:promotion => promotion,
                                  :discount_percent => promotion.discount_percent,
                                  :discount_value =>  apply_discount(promotion))
    end
  end

  def satisfies_criteria? promotion
     strategy = promotion.load_strategy.new(promotion.param, user)
     strategy.matches?
  end
end
