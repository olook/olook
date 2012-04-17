class MenuPresenter < BasePresenter
  
  def render_item label, path, css_klass, hightlight_when
    h.content_tag(:li, h.link_to(label, path, :class => h.selected_if_current(hightlight_when)), :class => css_klass)
  end
  
  def render_menu
    user.half_user ? render_half_user_menu : render_default_menu
  end
  
  def render_default_menu
    [showroom, lookbooks, stylist, my_friends, invite, gift, liquidation, blog, cart].join.html_safe
  end
  
  def render_half_user_menu
    [lookbooks, stylist, my_friends, invite, gift, liquidation, blog, cart].join.html_safe
  end
  
  private
  
  def showroom
    render_item("Minha Vitrine", h.member_showroom_path, "showroom", ["members#showroom"]) if user.has_early_access?
  end
  
  def lookbooks
    render_item("Lookbooks", h.lookbooks_path, "lookbooks", ["lookbooks#show"])
  end
  
  def stylist
    render_item("Stylist", h.helena_linhares_path, "stylist", ['stylists#helena_linhares'])
  end
  
  def my_friends
    render_item("Minhas amigas", h.facebook_connect_path, "my_friends", ['friends#facebook_connect','friends#home','friends#showroom'])
  end
  
  def invite
    render_item("Convidar amigas", h.member_invite_path, "invite", ["members#invite"])
  end
  
  def gift
    render_item("Presentes", h.gift_root_path, "gift",
     [
      "gift/home#index",
      "gift/occasions#new",
      "gift/occasions#new_with_data",
      "gift/survey#new",
      "gift/recipients#edit",
      "gift/suggestions#index"
     ]
    )
  end
  
  def liquidation
    render_item(h.current_liquidation.name, h.liquidations_path(h.current_liquidation.id), "liquidation", ["liquidations#show"]) if h.current_liquidation
  end
  
  def cart
    h.content_tag :li, (h.render 'shared/cart', :order => @order), :id => "cart", :class => "cart" if user.has_early_access?   
  end
  
  def blog
    h.content_tag :li, h.link_to("Blog", "http://blog.olook.com.br", :target => "_blank"), :class => "blog" 
  end
end