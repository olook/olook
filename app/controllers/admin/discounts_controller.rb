class Admin::DiscountsController < Admin::BaseController

  respond_to :html
  def index
    @user_discounts = DiscountExpirationCheckService.find_all_discounts
  end
end
