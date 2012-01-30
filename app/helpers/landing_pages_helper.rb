# -*- encoding : utf-8 -*-
module LandingPagesHelper
  def button_position(page)
    style = ""
    style += "top:#{page.button_top}px;" if page.button_top.present?
    style += "left:#{page.button_left}px;" if page.button_left.present?
    style
  end
end
