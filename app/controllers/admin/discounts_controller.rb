class Admin::DiscountsController < Admin::BaseController

  respond_to :html

  load_and_authorize_resource
  
  def index

    @user_discounts = nil
    if params[:search]
      @search = User.search(params[:search]) if params[:search]
      @user_discounts = @search.order('created_at desc')
    else
      @user_discounts = DiscountExpirationCheckService.find_all_discounts
    end
    # @user_discounts = @search.order('created_at desc')
  end
end
