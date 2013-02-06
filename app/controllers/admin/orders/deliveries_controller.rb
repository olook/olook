# -*- encoding : utf-8 -*-
class Admin::Orders::DeliveriesController < Admin::BaseController
  include Admin::Orders::DeliveriesHelper

  def index
    @report_days = [*0..6]

    flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]}" if shipping_filter?

    flash[:notice] = "Filtrando por #{params[:freight_state]}" if freight_state_filter?

    flash[:notice] = "Filtrando por transportadora #{params[:shipping_service_name]} e por #{params[:freight_state]}" if shipping_filter? && freight_state_filter?
  end

  def show
    @number_of_days = params[:day_number].to_i
    @state = params[:state]

    options = params.merge(action: 'orders_time_report')

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

  private

   def today
     0.business_day.ago
   end

   def scope_date
     @number_of_days < 3 ? @number_of_days.business_days.before(today) : @number_of_days.business_days.after(today)
   end
end

