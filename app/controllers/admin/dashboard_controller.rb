# -*- encoding : utf-8 -*-
class Admin::DashboardController < Admin::BaseController

  def index
    @report_days = [*0..6]
    @statuses = %w{authorized picking delivering delivered authorized,picking,delivering,delivered}.to_a
  end

  def show

  end
end
