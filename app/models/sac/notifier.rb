module SAC
  
  class Notifier

    attr_accessor :alert, :delivery_method

    def self.notify(alert, delivery_method)
      delivery_method.initialize_triggers(alert.order_id)
      Resque.enqueue(SAC::AlertWorker, alert, delivery_method.type, delivery_method.subscribers) if delivery_method.active?
    end

  end
end