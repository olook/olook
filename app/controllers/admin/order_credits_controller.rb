class Admin::OrderCreditsController < Admin::BaseController
  def index
    @orders = Order.paid.order('amount_discount desc').page(params[:page]).per_page(15)
  end

  def orders_filtered_by_range
    @orders = Order.paid
              .where('amount_discount between :min_amount_discount and :max_amount_discount',{:min_amount_discount => params[:min_amount_discount].try(:to_i) || 0, 
                                                                                              :max_amount_discount => params[:max_amount_discount].try(:to_i) || 1000})
              .order('amount_discount desc').page(params[:page]).per_page(15)
    render :index
  end

  def orders_filtered_by_date
    @orders = Order.paid
              .where('created_at between :start_at and :end_at',{:start_at => params[:start_at] || 1.week.ago, 
                                                                 :end_at   => params[:end_at] || Time.zone.now})
              .order('amount_discount desc').page(params[:page]).per_page(15)
    render :index
  end
end