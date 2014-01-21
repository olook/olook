class WishlistController < ApplicationController
  before_filter :authenticate_user!
  layout 'lite_application'

  def show
    @wishlist = Wishlist.for(current_user)
  end
end
