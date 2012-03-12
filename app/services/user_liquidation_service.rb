class UserLiquidationService
  def initialize user, liquidation
    @user = user
    @liquidation = liquidation
    @user_liquidation = find_row
  end

  def show?
    @user_liquidation.dont_want_to_see_again if @user_liquidation 
  end

  def update boolean
    if @user_liquidation
      @user_liquidation.dont_want_to_see_again = boolean
      @user_liquidation.save
    else
      UserLiquidation.create(:user_id => @user.id, :liquidation_id => @liquidation.id, :dont_want_to_see_again => boolean)
    end
  end

  private

  def find_row
    if @liquidation
      @user_liquidation = UserLiquidation.where(:liquidation_id => @liquidation.id, :user_id => @user.id).last
    end
  end
end