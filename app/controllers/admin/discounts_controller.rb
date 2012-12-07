class Admin::DiscountsController < Admin::BaseController

  respond_to :html

  def index
      @user_discounts = params[:email] && params[:email].size > 0 ? DiscountExpirationCheckService.search(params[:email]) : DiscountExpirationCheckService.find_all_discounts.first(50)
  end
end
