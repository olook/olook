# -*- encoding : utf-8 -*-
class Users::GiftsController < ApplicationController
  layout "my_account"

  before_filter :authenticate_user!

  def index

  end
end
