module PromotionsHelper
  PROMOTION_BANNER_WHITELIST = [
      {:controller => "members", :actions => ["showroom", "welcome"]},
      {:controller => "lookbooks"},
      {:controller => "stylists"},
      {:controller => "friends", :actions => ["showroom"]},
      {:controller => "product", :actions => ["show"]}
  ]

  PROMOTION_BANNER_GUEST_WHITELIST = [
    {:controller => "product", :actions => ["show"]}
  ]

  def render_promotion_banner
    promotion = PromotionService.new(@user).detect_current_promotion if @user
    if promotion and @user and page_included_in_whitelist?(PROMOTION_BANNER_WHITELIST)
      render(:partial => "promotions/banners/#{@promotion.strategy}", :locals => {:promotion => @promotion})
    elsif !current_user && page_included_in_whitelist?(PROMOTION_BANNER_GUEST_WHITELIST)
      render(:partial => "promotions/banners/#{Promotion.purchases_amount.strategy}", :locals => {:promotion => Promotion.purchases_amount})
    end
  end

  def page_included_in_whitelist? list
    result = false
    list.each do|whitelist|
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
