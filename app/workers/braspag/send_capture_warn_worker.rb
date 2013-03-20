# -*- encoding : utf-8 -*-
class SendCaptureWarnWorker
  @queue = :order_status

  def self.perform
    @warn_payments = BraspagAuthorizeResponse.find_by_sql("select p.id, a.identification_code, p.state, a.created_at from braspag_authorize_responses a left join braspag_capture_responses c  on a.identification_code = c.identification_code join payments p on a.identification_code = p.identification_code  where c.id is null and a.status = 1 and (a.created_at >= '#{(Time.zone.today - 15.days).strftime('%Y-%m-%d %H:%M:%S')}' and a.created_at <= '#{(Time.zone.today - 2.days).strftime('%Y-%m-%d %H:%M:%S')}') and p.state <> 'cancelled' order by a.created_at desc")
    mail = DevAlertMailer.braspag_capture_warn.delivery unless @warn_payments.empty?
  end
end
