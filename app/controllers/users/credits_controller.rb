# -*- encoding : utf-8 -*-
class Users::CreditsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!

  def index
    
  end
  
end

