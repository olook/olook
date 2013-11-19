module PromotionsHelper
  PROMOTION_BANNER_WHITELIST = [
      {:controller => "stylists"},
      {:controller => "friends", :actions => ["showroom"]},
      {:controller => "product", :actions => ["show"]},
      {:controller => "home"}
  ]

  PROMOTION_BANNER_GUEST_WHITELIST = [
    {:controller => "product", :actions => ["show"]},
    {:controller => "home", :actions => ["index"]}
  ]

  def render_promotion_banner

    # Please, do not delete these commented code, cause the product guys are ALWAYS asking to change it (delete, rollback, delete, rolback...)
    # As son as we got time to think in a more persistent rule, we'll stop doing this.

    # promotion = PromotionService.new(@user).detect_current_promotion(@cart) if @user
    # if promotion && @user && page_included_in_whitelist?(PROMOTION_BANNER_WHITELIST)
    #   render(:partial => "promotions/banners/#{promotion.strategy}", :locals => {:promotion => promotion})
    # elsif !current_user && page_included_in_whitelist?(PROMOTION_BANNER_GUEST_WHITELIST) && Promotion.purchases_amount
    #   render(:partial => "promotions/banners/#{Promotion.purchases_amount.strategy}", :locals => {:promotion => Promotion.purchases_amount})
    # elsif Campaign.activated_campaign && ((current_user && page_included_in_whitelist?(PROMOTION_BANNER_WHITELIST)) || (!current_user && page_included_in_whitelist?(PROMOTION_BANNER_GUEST_WHITELIST)))
    #   render(:partial => "campaigns/campaign_active")
    # end
    campaign = Campaign.activated_campaign
    if campaign && campaign.show_banner_for?(params)
      render(:partial => "campaigns/campaign_active")
    end

  end

  def page_included_in_whitelist? list
    result = false
    list.each do|whitelist|
      if whitelist[:controller] == controller_path
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
