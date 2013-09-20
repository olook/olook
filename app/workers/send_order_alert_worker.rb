# -*- encoding : utf-8 -*-
class SendOrderAlertWorker
  @queue = :order_status_alert

  def self.perform
    if Time.zone.now.hour == 11
      @warn_payments = BraspagAuthorizeResponse.find_by_sql("select p.id, a.identification_code, p.state, a.created_at from braspag_authorize_responses a left join braspag_capture_responses c  on a.identification_code = c.identification_code join payments p on a.identification_code = p.identification_code  where c.id is null and a.status = 1 and (a.created_at >= '#{(Time.zone.today - 15.days).strftime('%Y-%m-%d %H:%M:%S')}' and a.created_at <= '#{(Time.zone.today - 3.days).strftime('%Y-%m-%d %H:%M:%S')}') and p.state <> 'cancelled' order by a.created_at desc")
      @warn_orders = Order.select("number, created_at").where(state: "Authorized").where(erp_payment_at: nil).where(created_at: (Time.zone.today.beginning_of_day - 15.days)..(Time.zone.today.end_of_day - 3.days)).order("created_at DESC")
      unless @warn_payments.empty? && @warn_orders.empty?
        mail = DevAlertMailer.order_warns(@warn_payments, @warn_orders)
        mail.deliver!
      end
    end
  end
end
