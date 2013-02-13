# -*- encoding : utf-8 -*-
class Admin::DashboardController < Admin::BaseController
  include Admin::DashboardHelper

  def index

  end

  def show
    @number_of_days = params[:day_number].to_i
    @state = params[:state]

    options = request.referer.match(/orders_time_report/) ? params.merge(action: 'orders_time_report') : params

    @orders = build_scope(scope_date, options).
                    page(params[:page]).
                    per_page(15).
                    order('created_at desc')

    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv }
      format.xls
    end
  end

  def orders_status_report
    @report_days, @totals = [*0..10], []

    [:@authorized, :@picking, :@delivering, :@delivered].each do |name|
      state_counts = []

      params.merge!(state: name.to_s.delete('@'))

      @report_days.each do |number_of_days|
        state_counts << build_scope(number_of_days.days.ago, params).count
      end

      instance_variable_set(name, state_counts)

      state_total = state_counts.inject(0) { |total, value| total += value }

      instance_variable_set("#{name}_total", state_total)

      flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]}" if shipping_filter?

      flash[:notice] = "Filtrando por #{params[:freight_state]}" if freight_state_filter?

      flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]} e por #{params[:freight_state]}" if shipping_filter? && freight_state_filter?
    end

    @report_days.each do |index|
      @totals << (@authorized[index] + @picking[index] + @delivering[index] + @delivered[index])
    end

    @grand_total = @totals.inject(0) { |total, value| total += value }
  end

  def orders_time_report
    @report_days = [*0..6]

    flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]}" if shipping_filter?

    flash[:notice] = "Filtrando por #{params[:freight_state]}" if freight_state_filter?

    flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]} e por #{params[:freight_state]}" if shipping_filter? && freight_state_filter?
  end

  private

   def today
     0.business_day.ago
   end

   def scope_date
     if request.referer.match /orders_time_report/
       @number_of_days < 3 ? @number_of_days.business_days.before(today) : @number_of_days.business_days.after(today)
     else
       @number_of_days.days.ago
     end
   end
end

