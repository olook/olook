class ClearSaleReport < Report

  def schedule_generation
    Resque.enqueue(ClearSaleReportWorker, @start_date, @end_date, @admin.email)
  end
end
