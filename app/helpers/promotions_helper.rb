module PromotionsHelper
  def render_promotion_banner
    if @promotion and current_user
      render(:partial => "promotions/banners/#{@promotion.name.gsub(' ', '_')}")
    end
  end
end
