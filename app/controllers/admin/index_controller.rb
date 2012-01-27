# -*- encoding : utf-8 -*-
class Admin::IndexController < Admin::BaseController
#load_and_authorize_resource

  def dashboard
    get_version = `dpkg -l | grep olook | awk '{ print $3 }'`.chomp
    @app_version = get_version.nil? ? get_version : "We was unable to check app version."
  end
end
