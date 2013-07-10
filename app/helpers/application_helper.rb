# -*- encoding : utf-8 -*-
module ApplicationHelper
  def underscore_case(string)
    string.parameterize.gsub('-', '_')
  end

  def stylesheet_application
    stylesheet_link_tag  "application"
  end

  def is_current?(controller_name, action_name='index')
    'selected' if controller_name == params[:controller] and action_name == params[:action]
  end

  def selected_if_current(controller_action)
    controller_action.each do |item|
      subs = item.split("#")
      category = subs[2]
      return 'selected' if (subs[0] == params[:controller]) && (subs[1] == params[:action]) && (category==nil || category.to_s == params[:category])
      return nil
    end
  end

  def present(presenter_class, objects)
    klass ||= "#{presenter_class}Presenter".constantize
    presenter = klass.new(self, objects)
    yield presenter if block_given?
    presenter
  end

  def cart_total(cart)
    content_tag(:span,"(#{content_tag(:span, "#{pluralize(cart.try(:items_total).to_i, 'item', 'itens')}", :id => "cart_items")})".html_safe)
  end

  def discount_percentage(value)
    if value > 0
      "(#{number_to_percentage(value, :precision => 0)})"
    end
  end

  def track_event(*args)
    options = args.last.is_a?(Hash) ? args.last : {}
    category = args[0]
    raise ArgumentError.new('You should pass "category" first argument') unless category
    action = args[1]
    raise ArgumentError.new('You should pass "action" second argument') unless action
    item = args[2] || ''
    no_interactive = !!options[:no_interactive]

    if no_interactive
      "_gaq.push(['_trackEvent', '#{category}', '#{action}', '#{item}', , true]);"
    else
      "_gaq.push(['_trackEvent', '#{category}', '#{action}', '#{item}']);"
    end
  end

  def track_add_to_cart_event(product_id = '')
    track_event("Shopping", "AddToCart#{ga_event_referer}", product_id)
  end

  def track_add_to_cart_valentines_day_event(product_id = '')
    track_event("Shopping", "AddToCartValentinesDay#{ga_event_referer}", product_id)
  end

  def user_avatar(user, type = "large")
    "https://graph.facebook.com/#{user.uid}/picture?type=#{type}"
  end

  def member_type
    sufix = signed_newsletter? ? '-newsletter' : ''
    if user_signed_in?
      current_user.half_user ? "half#{sufix}" : "quiz#{sufix}"
    else
      "visitor#{sufix}"
    end
  end

  def signed_newsletter?
    cookies['newsletterUser'] == '1'
  end

  def quantity_status(product, user)
    if product.sold_out?
      'sold_out'
    elsif user && user.shoes_size && product.shoe?
      quantity = product.quantity(user.shoes_size)
      if quantity == 0
        'sold_out'
      elsif quantity > 0 && quantity < 4
        'stock_down'
      end
    end
  end

  def quantity_status_moments(product, shoe_size)
    if product.sold_out?
      'sold_out'
    elsif shoe_size && product.shoe?
      quantity = product.quantity(shoe_size)
      if quantity == 0
        'sold_out'
      elsif quantity > 0 && quantity < 4
        'stock_down'
      end
    end
  end

  def item_qty_max_option(item)
    [item.variant.inventory, Setting.default_item_quantity.to_i].min
  end

  def item_qty_select(item)
    if item.variant.inventory == 1
      '1 (última peça!)'
    else
      select_tag('quantity', options_for_select((1..item_qty_max_option(item)).to_a, item.quantity), onchange: "changeCartItemQty('#{item.id}');")
    end
  end

  def section_name section
    section_name = Category.t(section)
    section_name.nil? ? 'Coleções' : section_name
  end

  def is_moment_page?
    params[:controller] == "moments" && ["show", "clothes"].include?(params[:action]) && @featured_products
  end

  def protocol
    Rails.env.production? ? 'https' : 'http'
  end

  #
  # => ATTENTION
  # IF YOU NEED TO CHANGE ANY LINK DON'T (DONT!!!!!!!) FORGET ABOUT UPDATING THE G.A. TRACKING!!!!!
  #
  def banner_for category_id

    return link_to(image_tag('moments/banner_marca_olook.jpg'), '/colecoes/olook?utf8=%E2%9C%93&slug=olook&category_id=4&sort_filter=1&price=0-600&shoe_sizes[]=', onclick: track_event('Catalog', "ClickSideBannerFrom#{Category.key_for(@category_id).to_s.camelize}")) #if category_id.blank?

     # if category_id == Category::SHOE
     #   link_to(image_tag('moments/j3.gif'), collection_theme_path("estilista-juliana-jabour"), onclick: track_event('Catalog', "ClickSideBannerFrom#{Category.key_for(Category::SHOE).to_s.camelize}", "Juliana Jabour"))
     # elsif category_id == Category::ACCESSORY
     #   link_to(image_tag('moments/c2.jpg'), collection_theme_path("carol-ribeiro"), onclick: track_event('Catalog', "ClickSideBannerFrom#{Category.key_for(Category::ACCESSORY).to_s.camelize}", "Carol Ribeiro"))
     # elsif category_id == Category::CLOTH
     #   link_to(image_tag('moments/c1.gif'), collection_theme_path("carol-ribeiro"), onclick: track_event('Catalog', "ClickSideBannerFrom#{Category.key_for(Category::CLOTH).to_s.camelize}", "Carol Ribeiro"))
     # elsif category_id == Category::BAG
     #   link_to(image_tag('moments/j2.jpg'), collection_theme_path("estilista-juliana-jabour"), onclick: track_event('Catalog', "ClickSideBannerFrom#{Category.key_for(Category::CLOTH).to_s.camelize}", "Juliana Jabour"))
     # end
  end

  # def valentine_link_for(user, product)
  #   "#{root_url}dia_dos_namorados/#{IntegerEncoder.encode(user.id)}/#{product.id.to_s}"
  # end

  private

    def ga_event_referer
      case request.referer
        when /olook.com.br(\/)?$/
          'FromHome'
        when /vitrine/
          'FromVitrine'
        when /tendencias/
          'FromTendencias'
        when /colecoes/
          'FromColecoes'
        when /sapatos/
          'FromSapatos'
        when /roupas/
          'FromRoupas'
        when /bolsas/
          'FromBolsas'
        when /acessorios/
          'FromAcessorios'
        when /oculos/
          'FromOculos'
        when /stylists/
          'FromStylists'
        when /presentes/
          'FromPresentes'
        else
          ''
        end
    end
end
