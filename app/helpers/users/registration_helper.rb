module Users::RegistrationHelper

  def registration_for_checkout?
    params[:checkout_registration] == "true"
  end
end