class UserLiquidationsController < ApplicationController
  respond_to :json

  def update
    user_liquidation_service = UserLiquidationService.new(current_user, LiquidationService.active)
    @user_liquidation = user_liquidation_service.update(params[:user_liquidation][:dont_want_to_see_again])
    respond_with @user_liquidation
  end
end
