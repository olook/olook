# -*- encoding : utf-8 -*-
class PagesController < ApplicationController

  before_filter :authenticate_user!, :only => [:welcome]

  def welcome
    @member = current_user
  end

end
