# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform(method_called, filename, adapt_encoding, info_ftp = nil, schedule_error_fallback_hour = nil)
    return if schedule_error_fallback_hour && Time.zone.now.hour != schedule_error_fallback_hour

    type = method_called.to_sym
    ::MarketingReports::Builder.new(type).save_file(filename, adapt_encoding, info_ftp)
  end
end

