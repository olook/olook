# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform(method_called, filename, info_ftp = nil)
    type = method_called.to_sym
    ::MarketingReports::Builder.new(type).save_file(filename, info_ftp)
  end
end

