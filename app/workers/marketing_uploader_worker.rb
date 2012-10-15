# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform(method_called, filename, info_ftp)
    MarketingReports::Builder.new(method_called).save_file(filename, info_ftp)
  end
end

