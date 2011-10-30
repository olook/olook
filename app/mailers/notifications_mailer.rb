# -*- encoding : utf-8 -*-
class NotificationsMailer
  attr_accessor :message

  def initialize(message = Mailee::Message)
    @message = message
  end

  def signup(user_id)
    attributes = MAILEE_CONFIG[:welcome]
    attributes[:emails] = User.find(user_id).email
    signup_notification = message.create(attributes)
    signup_notification.ready unless Rails.env == "test"
  end
end
