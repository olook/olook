class UserLiquidationsController < ApplicationController
  def update
    user_liquidation_service = UserLiquidationService.new(current_user, LiquidationService.active)
    @user_liquidation = user_liquidation_service.update(params[:user_liquidation][:dont_want_to_see_again])
    respond_to do |format|
      format.json { render :json => @user_liquidation.to_json }
    end 
  end

  def notification_update
	@user_liquidation = UserLiquidation.find_or_create_by_user_id_and_liquidation_id(current_user.id, 4949)
    @user_liquidation.dont_want_to_see_again = (params[:user_notification][:dont_want_to_see_again])
    @user_liquidation.save
    respond_to do |format|
      format.json { render :json => @user_liquidation.to_json }
    end
  end
end
