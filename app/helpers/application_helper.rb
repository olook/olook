# -*- encoding : utf-8 -*-
module ApplicationHelper
  def stylesheet_application
    stylesheet_link_tag  "application"
  end
  
  def is_current?(controller_name, action_name='index')
    'selected' if params[:controller] == controller_name and params[:action] == action_name
  end
  
  def render_google_remessaging_scripts
    if user_signed_in?
      render "shared/metrics/google/google_remessaging_member"
    else
      render "shared/metrics/google/google_remessaging_visitor"
    end
  end
end
