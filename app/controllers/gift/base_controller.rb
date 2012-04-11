class Gift::BaseController < ApplicationController
  
  before_filter :check_facebook_permissions, :load_facebook_adapter, :load_friends
  
  def current_month
    Time.now.month
  end
  
  def check_facebook_permissions
    session[:facebook_scopes] = User::FACEBOOK_FRIENDS_BIRTHDAY
  end  

  def load_facebook_adapter
    @facebook_adapter = FacebookAdapter.new current_user.facebook_token if current_user and current_user.has_facebook?
  end
  
  def load_friends 
    @friends = @facebook_adapter.facebook_friends_with_birthday(current_month) if @facebook_adapter
  end
end
