module PromotionsHelper
  NOT_RENDER_PROMOTION_BANNER = ["credit_cards", "addresses", "debits", "payments", "billets", "product", "cart"]
  def render_promotion_banner
    if @promotion and current_user and not NOT_RENDER_PROMOTION_BANNER.include? controller_name
      render(:partial => "promotions/banners/#{@promotion.name.gsub(' ', '_')}")
    end
  end
end
