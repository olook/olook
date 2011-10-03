class PagesController < ApplicationController
  def welcome
    @member = current_user
  end
end
