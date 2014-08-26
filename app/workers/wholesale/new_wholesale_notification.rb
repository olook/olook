class NewWholesaleNotification
  @queue = 'low'

  def self.perform(wholesale)
    _wholesale = Wholesale.new(wholesale)
    SACAlertMailer.wholesale_notification(_wholesale).deliver
  end
end

