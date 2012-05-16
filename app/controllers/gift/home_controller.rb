# -*- encoding : utf-8 -*-
class Gift::HomeController < Gift::BaseController
  before_filter :load_user, :check_facebook_permissions, :load_facebook_adapter, :load_friends
  rescue_from Koala::Facebook::APIError, :with => :facebook_api_error

  def index
  end

  def update_birthdays_by_month
    @friends = @facebook_adapter.facebook_friends_with_birthday(params[:month]) if @facebook_adapter
  end

  def current_month
    Time.now.month
  end

  def check_facebook_permissions
    if @user && @user.has_facebook_friends_birthday?
      session[:facebook_scopes] = nil
    else
      session[:facebook_redirect_paths] = "gift"
    end
  end

  def load_facebook_adapter
    if current_user && current_user.has_facebook_friends_birthday?
      @facebook_adapter = FacebookAdapter.new current_user.facebook_token
    end
  end

  def load_friends
    @friends = @facebook_adapter.facebook_friends_with_birthday(current_month) if @facebook_adapter
  end

  private

  def facebook_api_error
    respond_to do |format|
      format.html { redirect_to(gift_root_path, :alert => I18n.t("facebook.connect_failure")) }
      format.js { head :error }
    end
  end

end
