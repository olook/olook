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
    @report_days, @totals = [*0..6], []

    [:@authorized, :@picking, :@delivering, :@delivered].each do |name|
      state_counts = []

      @report_days.each do |report_day|
        state_counts << Order.with_date(report_day.business_days.before(Time.now)).with_state(name.to_s.delete('@')).count
      end

      instance_variable_set(name, state_counts)

      state_total = state_counts.inject(0) { |total, value| total += value }

      instance_variable_set("#{name}_total", state_total)
    end

    @report_days.each do |index|
      @totals << (@authorized[index] + @picking[index] + @delivering[index] + @delivered[index])
    end

    @grand_total = @totals.inject(0) { |total, value| total += value }
  end

  def orders_time_report
    @report_days = [*0..6]
  end
end

