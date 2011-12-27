class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
end
