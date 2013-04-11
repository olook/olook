# -*- encoding : utf-8 -*-
class Admin::ProcessBilletFileWorker
  @queue = :process_billet_file

  def self.perform
    processed_billets = BilletService.process_billets
    send_notification processed_billets
  end

  private
    def self.send_notification processed_billets
      BilletSummaryMailer.send_billet_summary(processed_billets).deliver
    end
end
