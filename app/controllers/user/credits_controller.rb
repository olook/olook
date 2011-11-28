# -*- encoding : utf-8 -*-
class User::CreditsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user

  def index
  end

  private

  def load_user
    @user = current_user
  end
end
