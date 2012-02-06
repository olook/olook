module PromotionsHelper
  PROMOTION_BANNER_WHITELIST = [
      {:controller => "members", :actions => ["showroom"]},
      {:controller => "lookbooks"},
      {:controller => "stylists"},
      {:controller => "friends", :actions => ["showroom"]}
  ]

  def render_promotion_banner
    if @promotion and current_user and page_included_in_whitelist?
      render(:partial => "promotions/banners/#{@promotion.strategy}")
    end
  end

  def page_included_in_whitelist?
    result = false
    PROMOTION_BANNER_WHITELIST.each do|whitelist|
      if whitelist[:controller] == controller_name
        if whitelist[:actions]
          result = whitelist[:actions].include? action_name
        else
          result = true
        end
      end
      break if result
    end
    result
  end
end
