class Gift::HomeController < ApplicationController
  layout "gift"
  FACEBOOK_BIRTHDAY_SCOPE = "friends_birthday"
  
  before_filter :check_facebook_permissions
  

  def index
    @facebook_adapter = FacebookAdapter.new current_user.facebook_token
    @friends = @facebook_adapter.facebook_friends_with_birthday(current_month)
  end
  
  def update_birthdays_by_month
    @facebook_adapter = FacebookAdapter.new current_user.facebook_token
    @friends = @facebook_adapter.facebook_friends_with_birthday(params[:month])
  end
  
  private
  
  def current_month
    Time.now.month
  end
  
  def check_facebook_permissions
    session[:facebook_scopes] = FACEBOOK_BIRTHDAY_SCOPE
  end  

end
