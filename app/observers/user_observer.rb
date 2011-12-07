# -*- encoding : utf-8 -*-
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Resque.enqueue_in(1.hour, ShowroomReadyNotificationWorker, user.id)
    user.add_event(EventType::SIGNUP)
  end
end

