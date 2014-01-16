# -*- encoding : utf-8 -*-
class Admin::Orders::NewestReportsController < Admin::BaseController
  def index
    @orders = Order.with_first_buyers
  end
end
