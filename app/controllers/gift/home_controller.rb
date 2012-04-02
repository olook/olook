class Gift::HomeController < ApplicationController
  layout "gift"

  def index
    #@facebook_adapter = FacebookAdapter.new @user.facebook_token
    @friends = []
  end

end
