# -*- encoding : utf-8 -*-
module SAC
	class AlertWorker
	  @queue = :SAC_notifications

	  def self.perform(alert)
	    mail = SACAlertMailer.send_notification(alert)
	    mail.deliver
	  end
	end
end