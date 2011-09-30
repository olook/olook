class SessionsController < Devise::SessionsController
  private
 
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) 
      welcome_url
    end
  end
 
end