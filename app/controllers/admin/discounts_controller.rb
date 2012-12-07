class Admin::DiscountsController < Admin::BaseController

  respond_to :html

  def index
      @user_discounts = DiscountExpirationCheckService.search(params[:email][:search])
  end
end
