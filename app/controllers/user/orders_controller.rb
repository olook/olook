# -*- encoding : utf-8 -*-
class User::OrdersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user

  def index
  end

  def show
  end

  private

  def load_user
    @user = current_user
  end
end
