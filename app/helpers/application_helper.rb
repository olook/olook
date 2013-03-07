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
      return 'selected' if (subs[0] == params[:controller]) && (subs[1] == params[:action]) && (category==nil || category.to_i==params[:category_id])
    end
  end

  def present(presenter_class, objects)
    klass ||= "#{presenter_class}Presenter".constantize
    presenter = klass.new(self, objects)
    yield presenter if block_given?
    presenter
  end

  def cart_total(cart)
    content_tag(:span,"(#{content_tag(:span, "#{pluralize(cart.items_total, 'item', 'itens')}", :id => "cart_items")})".html_safe)
  end

  def discount_percentage(value)
    if value > 0
      "(#{number_to_percentage(value, :precision => 0)})"
    end
  end

  def track_event(category, action, item = '')
    "_gaq.push(['_trackEvent', '#{category}', '#{action}', '#{item}']);"
  end

  def track_add_to_cart_event(product_id = '')
    track_event("Shopping", "AddToCart#{ga_event_referer}", product_id)
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
    case
    when section == 1
      'Sapatos'
    when section == 2
      'Bolsas'
    when section == 3
      'Acessórios'
    else
      'Coleções'
    end
  end

  def is_moment_page?
    params[:controller] == "moments" && params[:action] == "show" && @featured_products
  end

  def protocol
    Rails.env.production? ? 'https' : 'http'
  end

  private

    def ga_event_referer
      case request.referer
        when /vitrine/
          'FromVitrine'
        when /tendencias/
          'FromTendencias'
        when /colecoes/
          'FromColecoes'
        when /sapatos/
          'FromSapatos'
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
