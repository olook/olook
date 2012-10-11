# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform(method_called, file, ftp = nil)
    MarketingReports::Builder.new(method_called).save_file(file, ftp)
  end
end

