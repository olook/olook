class AlertForFraud
  
  def self.perform(order_number)
    @order = Order.find_by_number(order_number)
    catch(:stop_alert) do
      self.validate_discount
      
      mail = SACAlertMailer.fraud_analysis_notification(@order, Setting.sac_fraud_subscribers)
      mail.deliver!
    end
  end
  
  def self.validate_discount
    discounts_percent = @order.payments.with_discount.sum(:percent)
    if (discounts_percent <= BigDecimal.new(Setting.sac_total_discount_threshold_percent.to_s))
      throw :stop_alert
    end
  end
end
