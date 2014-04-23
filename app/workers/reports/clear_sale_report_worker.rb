class ClearSaleReportWorker

  @queue = 'low'

  def self.perform(start_date, end_date, admin_email)
    parsed_start_date = Date.parse start_date
    parsed_end_date = Date.parse end_date

    filepath = ClearSaleReport.report_file(parsed_start_date, parsed_end_date)
    mail = AdminReportMailer.send_report(filepath, admin_email)
    mail.deliver
  end

end
