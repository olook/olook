# -*- encoding : utf-8 -*-
class Admin::Orders::BilletReportsController < Admin::BaseController
  def index
    @billets = Billet.expire_at(Time.zone.now - 1.days, Time.zone.now)
  end
end
