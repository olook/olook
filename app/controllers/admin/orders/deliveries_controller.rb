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

    @orders = build_delivery_scope(scope_date, params).
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
     biz_days = case @number_of_days
                when 0
                  3
                when 1
                  2
                when 2
                  1
                when 3
                  0
                when 4
                  1
                when 5
                  2
                else 6
                  3                       
                end

     @number_of_days < 3 ? biz_days.business_days.before(today) : biz_days.business_days.after(today)
   end
end

