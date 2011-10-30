# -*- encoding : utf-8 -*-
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.events.create(type: EventType::SIGNUP, description: "Sign up")
  end
end

