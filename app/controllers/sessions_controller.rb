# -*- encoding : utf-8 -*-
class SessionsController < Devise::SessionsController
  private

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      member_invite_path
    else
      admin_path
    end
  end

end
