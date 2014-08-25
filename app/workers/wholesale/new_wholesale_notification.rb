class NewWholesaleNotification
  @queue = 'low'

  def self.perform(wholesale)
    SACAlertMailer.wholesale_notification(wholesale).deliver
  end
end

