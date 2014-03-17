class Admin::OrderCreditsController < Admin::BaseController
  def index
    @search = Order.search(params[:search])
    @orders = @search.relation
                      .payments_with_discount(params[:percentage].to_s.to_f)
                      .order('orders.created_at desc,amount_of_percent desc')
                      .page(params[:page])
                      .per_page(15)
  end
end
