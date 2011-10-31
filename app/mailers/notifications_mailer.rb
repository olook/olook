# -*- encoding : utf-8 -*-
class NotificationsMailer
  attr_accessor :message

  def initialize(message = Mailee::Message)
    @message = message
  end

  def signup(user_id)
    attributes = MAILEE_CONFIG[:welcome]
    member = User.find(user_id)

    attributes[:subject] = attributes[:subject].gsub /__member_name__/, member.name
    attributes[:emails] = member.email
    
    signup_notification = message.create(attributes)
    signup_notification.ready unless Rails.env == "test"
  end
end
