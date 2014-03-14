# -*- encoding : utf-8 -*-
class Admin::NewestReportsController < Admin::BaseController
  def index
    @orders = Order.between.with_first_buyers
  end
end
