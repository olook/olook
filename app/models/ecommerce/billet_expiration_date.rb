# -*- encoding : utf-8 -*-
class BilletExpirationDate



  def self.business_day_expiration_date(base_date = Time.zone.now)
  	days_to_expire = Setting.billet_days_to_expire.to_i
    days_to_expire.business_days.after(base_date)
  end

end
