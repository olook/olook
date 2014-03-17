# -*- encoding : utf-8 -*-
class Admin::BilletReportsController < Admin::BaseController
  authorize_resource :class => false
  def index
    @billets = Billet.expire_at(Time.zone.now)
  end
end
