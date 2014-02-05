# -*- encoding : utf-8 -*-
class Admin::Orders::NewestReportsController < Admin::BaseController
  def index
    @orders = Order.between.with_first_buyers
  end
end
