class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    resource.counts_and_write_points(session[:profile_points])
  end
end
