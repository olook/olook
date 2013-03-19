# -*- encoding : utf-8 -*-
class SendCaptureWarnWorker
  @queue = :order_status

  def self.perform
    mail = DevAlertMailer.braspag_capture_warn
  end
end
