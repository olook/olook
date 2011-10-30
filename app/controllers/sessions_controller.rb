# -*- encoding : utf-8 -*-
class SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  protected  

  def create_sign_in_event
    if current_user.is_a?(User)
      current_user.events.create(type: EventType::SIGNIN, description: "Sign in")
    end
  end

  def create_sign_out_event
    if current_user.is_a?(User)
      current_user.events.create(type: EventType::SIGNOUT, description: "Sign out")
    end
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Admin)
      admin_path
    else
      member_invite_path
    end
  end

end
