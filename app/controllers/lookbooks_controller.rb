class LookbooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_order
end
