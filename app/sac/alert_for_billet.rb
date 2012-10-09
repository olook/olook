# -*- encoding : utf-8 -*-
class AlertForBillet
  def self.perform(order_number)
    @order = Order.find_by_number(order_number)
    catch(:stop_alert) do

      self.validate_payment_is_billet
      self.validate_business_days
      self.validate_business_hours
      self.validate_purchase_amount
      
      mail = SACAlertMailer.billet_notification(@order, Setting.sac_billet_subscribers)
      mail.deliver!
    end
  end
  
  private
  
  def self.validate_payment_is_billet
    throw :stop_alert unless @order.erp_payment.is_a?(Billet)
  end
  
  def self.validate_business_days
    if (Date.today.saturday? || Date.today.sunday?)
       throw :stop_alert
    end
  end

  def self.validate_business_hours
    unless ( Time.now > Time.parse(Setting.sac_beginning_working_hour) && 
         Time.now < Time.parse(Setting.sac_end_working_hour)
       )
        throw :stop_alert
    end
  end

  def self.validate_purchase_amount
    if (@order.amount_paid <= BigDecimal.new(Setting.sac_purchase_amount_threshold.to_s))
      throw :stop_alert
    end
  end
end
