class UserLiquidationsController < ApplicationController
  def update
    user_liquidation_service = UserLiquidationService.new(current_user, LiquidationService.active)
    @user_liquidation = user_liquidation_service.update(params[:user_liquidation][:dont_want_to_see_again])
    respond_to do |format|
      format.json { render :json => @user_liquidation.to_json }
    end 
  end
end
