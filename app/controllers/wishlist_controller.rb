class WishlistController < ApplicationController
  before_filter :authenticate_user!

  def show
    @wishlist = Wishlist.for(current_user)
    @wishlist = Wishlist.new
    @wishlist.add Product.find(17678).variants.first
    @wishlist.add Product.find(1730063051).variants.first
    @wishlist.add Product.find(17263).variants.first
    @wishlist.add Product.find(1730063051).variants.first
  end
end
