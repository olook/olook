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

  def display_heel_filters
    h.render :partial => 'liquidations/heel_filters', :locals => {:liquidation_presenter => self}
  end

  def display_bag_filters
    h.render :partial => 'liquidations/bag_filters', :locals => {:liquidation_presenter => self}
  end

  def display_accessory_filters
    h.render :partial => 'liquidations/accessory_filters', :locals => {:liquidation_presenter => self}
  end
end
