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

  def apply_promotion
    order.create_used_promotion(:promotion => detect_current_promotion) unless order.used_coupon
  end

  def satisfies_criteria? promotion
     strategy = promotion.load_strategy.new(promotion.param, user)
     strategy.matches?
  end
end
