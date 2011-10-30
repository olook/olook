# -*- encoding : utf-8 -*-
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.add_event(EventType::SIGNUP)
  end
end

