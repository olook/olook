# -*- encoding : utf-8 -*-
class Admin::IndexController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  def dashboard
  end
end
