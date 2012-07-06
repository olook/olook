# -*- encoding : utf-8 -*-
module SAC
	class AlertWorker
	  @queue = :sac

	  def self.perform(alert, type, subscribers)  
	    mail = SACAlertMailer.send("send_#{type}_alert", alert, subscribers)
	    mail.deliver
	  end
	end
end