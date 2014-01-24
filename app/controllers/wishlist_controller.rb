class WishlistController < ApplicationController
  # before_filter :authenticate_user!
  layout 'lite_application'

  def show
    if !current_user
      flash[:notice] = 'Entre para ver seus produtos favoritos...'
      after_login_return_to wishlist_path
      redirect_to :new_user_session
    else
      @wishlist = Wishlist.for(current_user)
    end
  end
end
