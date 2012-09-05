class Admin::OrderCreditsController < Admin::BaseController
  
  def index
    @search = Order.search(params[:search])
    @orders = @search.relation
                      .uniq
                      .payments_with_discount
                      .order('amount_discount desc, created_at desc')
                      .where('ifnull(payments.percent,0) >= ?',params[:percentage].to_s.to_f)
                      .page(params[:page]).per_page(15)
  end
end