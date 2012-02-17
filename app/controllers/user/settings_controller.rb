# -*- encoding : utf-8 -*-
class User::SettingsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
end
