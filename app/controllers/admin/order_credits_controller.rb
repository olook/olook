class Admin::OrderCreditsController < Admin::BaseController
  
  def index
    @search = Order.search(params[:search])
    @orders = @search.relation.uniq.payments_with_discount.order('amount_discount desc').page(params[:page]).per_page(15)
    percentage = params[:percentage]

    @orders = @orders.select do |order|
      total = order.payments.sum(&:total_paid)
      (order.amount_paid*100/percentage.to_f)-order.amount_paid >= total
    end if percentage

  end
end