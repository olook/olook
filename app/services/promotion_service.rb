class PromotionService
  attr_reader :user
  attr_accessor :promotions

  def initialize(user)
    @user = user
    @promotions = ::Promotion.active.order(:priority)
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

  def satisfies_criteria? promotion
    true
    #promotion.apply_strategy user
  end
end
