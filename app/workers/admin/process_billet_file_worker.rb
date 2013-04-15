# -*- encoding : utf-8 -*-
class Admin::ProcessBilletFileWorker
  @queue = :process_billet_file

  def self.perform(file_name)
    processed_billets = BilletService.process_billets(file_name)
    send_notification processed_billets
  end

  private
    def self.send_notification processed_billets
      BilletSummaryMailer.send_billet_summary(processed_billets).deliver
    end
end
