# -*- encoding : utf-8 -*-
class Admin::Orders::NewestReportsController < Admin::BaseController
  def index
    @orders = Order.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).joins(:user).group(:user_id).having("count(orders.id) = 1")
  end
end
