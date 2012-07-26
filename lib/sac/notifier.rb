# -*- encoding : utf-8 -*-
module SAC
  class Notifier

    def self.notify(notification)
      notification.initialize_triggers
      Resque.enqueue(SAC::AlertWorker, notification) if notification.active?
    end

  end
end