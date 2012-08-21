class Admin::OrderCreditsController < Admin::BaseController
  
  def index
    @search = Order.search(params[:search])
    @orders = @search.relation.paid.order('amount_discount desc').page(params[:page]).per_page(15)
  end
end