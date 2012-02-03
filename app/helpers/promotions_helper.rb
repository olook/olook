module PromotionsHelper
  PROMOTION_BANNER_WHITELIST = ["members", "lookbooks", "stylists"]
  #BLACKLIST = ["credit_cards", "addresses", "debits", "payments", "billets", "product", "cart"]
  def render_promotion_banner
    if @promotion and current_user and PROMOTION_BANNER_WHITELIST.include? controller_name
      render(:partial => "promotions/banners/#{@promotion.name.gsub(' ', '_')}")
    end
  end
end
