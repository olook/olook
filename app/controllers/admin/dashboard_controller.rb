# -*- encoding : utf-8 -*-
class Admin::DashboardController < Admin::BaseController

  def index

  end

  def show

  end

  def show
    day = params[:number]
    @orders = Order.with_date((Time.now - day.to_i.days)).with_state(params[:state]).page(params[:page]).page(params[:page]).per_page(15).order('created_at desc')
  end

  def orders_life_cicle_report
    @report_days = [*0..6]
    @authorized = []
    @report_days.each{|a| @authorized << Order.with_date(a.business_days.before(Time.now)).with_state('authorized').count}
  end

  def orders_time_report
    @report_days = [*0..6]
  end
end

