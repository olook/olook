# -*- encoding : utf-8 -*-
class LiquidationPresenter < BasePresenter

  def render_search_form
    h.render :partial => 'liquidations/search_form', :locals => {:liquidation_presenter => self}
  end

  def display_shoe_filters
    h.render :partial => 'liquidations/shoe_filters', :locals => {:liquidation_presenter => self}
  end

  def display_shoe_size_filters
    h.render :partial => 'liquidations/shoe_size_filters', :locals => {:liquidation_presenter => self}
  end
end
