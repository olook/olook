# -*- encoding : utf-8 -*-
module ApplicationHelper
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

  def order_total(order)
    total = order ? order.line_items.try(:count) : 0
    content_tag(:span,"(#{content_tag(:div, "#{total}", :id => "cart_items")})".html_safe)
  end
end
