# -*- encoding : utf-8 -*-
class Admin::DashboardController < Admin::BaseController

  def index
    @report_days = [*0..6]
  end
end
