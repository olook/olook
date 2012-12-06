class Admin::DiscountsController < Admin::BaseController

  respond_to :html
  def index
    @search = User.search(params[:search])
    @user_discounts = @search.order('created_at desc')
  end
end
