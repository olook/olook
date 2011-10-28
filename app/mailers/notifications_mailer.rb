class NotificationsMailer
  attr_accessor :message

  def initialize(message = Mailee::Message)
    @message = message
  end

  def signup(user_id)
    attributes = {
      :title => MAILEE_CONFIG["title"],
      :subject => MAILEE_CONFIG["subject"],
      :from_name => MAILEE_CONFIG["from_name"],
      :from_email => MAILEE_CONFIG["from_email"],
      :template_id => MAILEE_CONFIG["template_id"],
      :emails => User.find(user_id).email
    }
    signup_notification = message.create(attributes)
    signup_notification.ready unless Rails.env == "test"
  end
end
