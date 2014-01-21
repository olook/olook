# -*- encoding : utf-8 -*-
class Admin::Orders::BilletReportsController < Admin::BaseController
  def index
    @billets = Billet.expire_at(Time.zone.now)
  end
end
