# -*- encoding : utf-8 -*-
module ApplicationHelper
  def stylesheet_application
    stylesheet_link_tag  "application"
  end
  
  def is_current?(controller_name, action_name='index')
    'selected' if controller_name.include? params[:controller] and action_name.include? params[:action]
  end
  
  def render_google_remessaging_scripts
    if user_signed_in?
      render "shared/metrics/google/google_remessaging_member"
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
end
