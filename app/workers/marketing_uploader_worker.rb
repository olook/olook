# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform(method_called, file, info_file = nil)
    MarketingReports::Builder.new(method_called).save_file(file, info_file)
  end
end

