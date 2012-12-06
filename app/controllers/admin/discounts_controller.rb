class Admin::DiscountsController < Admin::BaseController

  respond_to :html
  def index
    @search = User.search(params[:search])
    @user_discounts = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end
end
