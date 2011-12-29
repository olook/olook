class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user

  def showroom
    @products = []
    15.times { @products << Product.all.shuffle.first }
  end
end
