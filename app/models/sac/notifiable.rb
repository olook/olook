module SAC
  module Notifiable
    include ActionSupport

    CONFIG = YAML.load_file("#{Rails.root.to_s}/config/sac_alert.yml")


    def initialize_triggers(order_id)
      @order_id = order_id
      self.triggers.each do |trigger, state|
        @active = self.send("validate_#{trigger}") if state
        return unless @active == true
      end
    end

    def active?
      active
    end


    def validate_business_days
      Date.today.weekday? ? true : false
    end

    def validate_business_hours
      (Time.now > Time.parse(settings['beginning_working_hour']) && 
        Time.now < Time.parse(settings['end_working_hour'])) ? true : false
    end

    def validate_purchase_amount
      order = Order.find(@order_id)
      if order
        Order.find(@order_id).total.to_f >= settings['purchase_amount_threshold'] ? true : false
      end
    end

    def validate_discount
      order = Order.find(@order_id)
      if order
        order_total = order.line_items_total.to_f
        total_discount = order.discount_from_coupon + order.credits.to_f
        (total_discount/order_total)*100 >= settings['total_discount_threshold_percent'] ? true : false
      end
    end

  end
end