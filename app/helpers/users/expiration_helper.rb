module Users::ExpirationHelper
  def user_expiration_month(user)
    "%02d" % ::DiscountExpirationCheckService.discount_expiration_date_for(user).month.to_s
  end

  def user_expiration_day(user)
    "%02d" % ::DiscountExpirationCheckService.discount_expiration_date_for(user).day.to_s
  end

end