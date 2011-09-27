class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.counts_and_write_points(session[:profile_points])
  end

end
