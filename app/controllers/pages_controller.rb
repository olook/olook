# -*- encoding : utf-8 -*-
class PagesController < ApplicationController

  before_filter :authenticate_user!, :only => [:welcome]

  def welcome
    @redirect_uri = welcome_path
    @member = current_user
  end

end
