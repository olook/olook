# -*- encoding : utf-8 -*-
class BilletExpirationDate

  SHIFT_DATE = {
    0 => 2,
    1 => 1,
    2 => 0,
    3 => 0,
    4 => 0,
    5 => 0,
    6 => 2
  }

  def self.expiration_for_two_business_day(base_date = Time.zone.now)
    two_days_from_now = base_date + 2.days
    two_days_from_now = two_days_from_now + SHIFT_DATE[two_days_from_now.wday].days
    two_days_from_now.to_date
  end

end
