# -*- encoding : utf-8 -*-
class Admin::IndexController < Admin::BaseController
  def dashboard
    get_version = `dpkg -l | grep olook | awk '{ print $3 }'`.chomp
    @app_version = get_version ? get_version : "Sorry! We were unable to check the application version."
  end
end

