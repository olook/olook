module Users::RegistrationHelper

  def registration_for_checkout?
    @cart && @cart.items.any?
  end
end