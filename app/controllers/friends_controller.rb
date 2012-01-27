class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user

  def showroom
    assign_facebook_friends
    @products = []
    15.times { @products << Product.all.shuffle.first }
  end

  def home
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    @not_registred_friends = facebook_adapter.facebook_friends_not_registered_at_olook
    @friends = facebook_adapter.facebook_friends_registered_at_olook
  end

  def update_friends_list
    @friends = facebook_adapter.olook_facebook_friends
  end

  private

  def assign_facebook_friends
    @friends = []
    7.times { @friends << User.where("id < ?", 100).shuffle.first }
  end
end
