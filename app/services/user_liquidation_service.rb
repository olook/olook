class UserLiquidationService
  def initialize user, liquidation
    @user = user
    @liquidation = liquidation
    @user_liquidation = find_row
  end

  def show?
    return false unless @liquidation
    if @user_liquidation 
      not @user_liquidation.dont_want_to_see_again 
    else
      true
    end
  end

  def update boolean
    if @user_liquidation
      @user_liquidation.dont_want_to_see_again = boolean
      @user_liquidation.save
    else
      @user_liquidation = UserLiquidation.create(
        :user_id => @user.id,
        :liquidation_id => @liquidation.id,
        :dont_want_to_see_again => boolean
      )
    end
    @user_liquidation
  end

  private

  def find_row
    if @liquidation
      @user_liquidation = UserLiquidation.where(:liquidation_id => @liquidation.id, :user_id => @user.id).last
    end
  end
end