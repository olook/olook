# -*- encoding : utf-8 -*-
class BilletExpirationDate

  DAYS_TO_EXPIRE = 2
  def self.business_day_expiration_date(base_date = Time.zone.now)
    DAYS_TO_EXPIRE.business_days.after(base_date)
  end

end
