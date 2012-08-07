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
      return 'selected' if (subs[0] == params[:controller]) && (subs[1] == params[:action])
    end
  end

  def render_google_remessaging_scripts
    if user_signed_in?
      if controller.controller_name == "orders"
        render "shared/metrics/google/google_sale_conversion"
      else
        render "shared/metrics/google/google_remessaging_member"
      end
    else
      render "shared/metrics/google/google_remessaging_visitor"
    end
  end

  def present(presenter_class, objects)
    klass ||= "#{presenter_class}Presenter".constantize
    presenter = klass.new(self, objects)
    yield presenter if block_given?
    presenter
  end

  def cart_total(cart)
    content_tag(:span,"(#{content_tag(:div, "#{cart.items_total}", :id => "cart_items")})".html_safe)
  end

  def discount_percentage(value)
    if value > 0
      "(#{number_to_percentage(value, :precision => 0)})"
    end
  end

  def track_event(category, action, item = '')
    "_gaq.push(['_trackEvent', '#{category}', '#{action}', '#{item}']);"
  end

  def user_avatar(user, type = "large")
    "https://graph.facebook.com/#{user.uid}/picture?type=#{type}"
  end

  def member_type
    user_signed_in? ? 'member' : 'visitor'
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
end
