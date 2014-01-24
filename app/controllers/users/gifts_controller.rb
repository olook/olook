# -*- encoding : utf-8 -*-
class Users::GiftsController < ApplicationController

  before_filter :authenticate_user!

  def index

  end
end
