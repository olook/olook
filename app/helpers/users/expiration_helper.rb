module Users::ExpirationHelper
  def user_expiration_date user
    DiscountExpirationDate.discount_expires_at(user)
  end
end