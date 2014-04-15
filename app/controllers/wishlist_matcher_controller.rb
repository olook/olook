class WishlistMatcherController < ApplicationController
  def index
    service = WishlistMatcherService.new
    @success = service.matches?(current_user.wishlist, params[:variant_id])
  end
end