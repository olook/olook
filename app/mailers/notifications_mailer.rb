# -*- encoding : utf-8 -*-
class NotificationsMailer
  attr_accessor :message

  def initialize(message = Mailee::Message)
    @message = message
  end

  def signup(user_id)
    attributes = MAILEE_CONFIG[:welcome]
    member = User.find(user_id)
    raise "The welcome message for member #{user_id} was already sent" unless member.welcome_sent_at.nil?

    template = Mailee::Template.find(attributes[:template_id])
    html = template.html.gsub /__member_name__/, member.name
    attributes.delete(:template_id)

    attributes[:subject] = attributes[:subject].gsub /__member_name__/, member.name
    attributes[:emails] = member.email
    attributes[:html] = html

    signup_notification = message.create(attributes)
    signup_notification.ready unless Rails.env == "test"

    member.welcome_sent_at = Time.now
    member.save
  end
end
