# -*- encoding : utf-8 -*-
class LiquidationPresenter < BasePresenter

  def render_search_form
    h.render :partial => 'liquidations/search_form', :locals => {:liquidation_presenter => self}
  end
end
