# -*- encoding : utf-8 -*-
module ApplicationHelper
  def stylesheet_application
    stylesheet_link_tag  "application"
  end
  
  def is_current?(controller_name, action_name='index')
    'selected' if params[:controller] == controller_name and params[:action] == action_name
  end
end
