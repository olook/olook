class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user

  def showroom
    assign_facebook_friends
    @products = []
    15.times { @products << Product.all.shuffle.first }
  end

  def home
    assign_facebook_friends
  end

  def update_friends_list
    assign_facebook_friends
  end

  private

  def assign_facebook_friends
    @friends = []
    7.times { @friends << User.where("id < ?", 100).shuffle.first }
  end
end
