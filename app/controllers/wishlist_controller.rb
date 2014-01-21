class WishlistController < ApplicationController
  before_filter :authenticate_user!

  def show
    @wishlist = Wishlist.for(current_user)
  end
end
