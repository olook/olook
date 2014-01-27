# -*- encoding : utf-8 -*
class MenuPresenter < BasePresenter

  def render_item label, path, css_klass, hightlight_when, mega_menu_template = nil
   #+(css_klass == "stylist" ? h.image_tag("home/only_balaozinho.png") : "")
    h.content_tag(:li, :class => css_klass) do
      out = h.link_to(label, path, :class => h.selected_if_current(hightlight_when))
      if mega_menu_template && !@mobile
        out += h.render mega_menu_template
      end
      out
    end
  end

  def render_item_with_label label, path, css_klass, hightlight_when
    h.content_tag :li, :class => css_klass do
      h.content_tag(:span, "Novo", :class => "label") +
      h.link_to(label, path, :class => h.selected_if_current(hightlight_when), :target => "_blank")
    end
  end

  def render_menu(mobile=false)
    @mobile = mobile
    [newest, stylist, collection_themes, categories, brands, gift, liquidation].join.html_safe
  end

  private
  def newest
    render_item("Novidades", h.newest_path, "showroom", ["list_products/newest_products#index"], 'mega_menu/showroom')
  end

  def brands
    render_item("Marcas", h.new_brands_path, "brands", ["brands#index", "brands#show"], 'mega_menu/brands')
  end

  def stylist
    render_item("BLOG", "http://www.olook.com.br/stylist-news", "stylist", ['stylists#helena_linhares'], 'mega_menu/blog')
  end

  def my_friends
    render_item("Minhas amigas", h.facebook_connect_path, "my_friends", ['friends#facebook_connect','friends#home','friends#showroom'])
  end

  def invite
    render_item("Convidar amigas", h.member_invite_path, "invite", ["members#invite"])
  end

  def collection_themes
    render_item("Coleções", h.collection_themes_path, "collection_themes", ["collection_themes#index", "collection_themes#show"], 'mega_menu/colecoes')
  end

  def categories
    [clothes, shoes, bags, accessories]
  end

  def clothes
    render_item("Roupas",  h.catalog_path(category: 'roupa'), "categories", ["catalogs#show#roupa"], 'mega_menu/roupas')
  end

  def shoes
    render_item("Sapatos", h.catalog_path(category: 'sapato'), "categories", ["catalogs#show#sapato"], 'mega_menu/sapatos')
  end

  def bags
    render_item("Bolsas", h.catalog_path(category: 'bolsa'), "categories", ["catalogs#show#bolsa"], 'mega_menu/bolsas')
  end

  def accessories
    render_item("Acessórios", h.catalog_path(category: 'acessorio'), "categories", ["catalogs#show#acessorio"], 'mega_menu/acessorios')
  end

  def glasses
    render_item("Óculos", h.glasses_path, "categories", ["moments#glasses"])
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
     ], 'mega_menu/presentes'
    )
  end

  def liquidation
    render_item('OLOOKLET', h.olooklet_path, "olooklet", ["olooklet#show"], 'mega_menu/olooklet')
  end

  def blog
    h.content_tag :li, h.link_to("Blog", "http://blog.olook.com.br", :target => "_blank"), :class => "blog"
  end
end

