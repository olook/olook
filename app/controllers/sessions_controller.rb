# -*- encoding : utf-8 -*-
class SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  protected

  def create_sign_in_event
    if current_user.is_a?(User)
      current_user.add_event(EventType::SIGNIN)
    end
  end

  def create_sign_out_event
    if current_user.is_a?(User)
      current_user.add_event(EventType::SIGNOUT)
    end
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Admin)
      admin_path
    else
      certifies_user
    end
  end

  def certifies_user
    if current_user.has_early_access?
      member_showroom_path
    else
      verifies_creation_date
    end
  end

  def verifies_creation_date
    # This will be on air soon
    #creation_date = current_user.created_at + 2.hours
    #if creation_date.strftime("%d/%m/%y %H:%M") <= Time.now.strftime("%d/%m/%y %H:%M")
    #  current_user.record_early_access
    member_showroom_path
    #else
    #  member_invite_path
    #end
  end
end

