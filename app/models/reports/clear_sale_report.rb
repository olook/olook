class ClearSaleReport < Report

  def schedule_generation
    start_date = Date.parse(@start_date)
    end_date = Date.parse(@end_date)
    Resque.enqueue_at(10.seconds, ClearSaleReportWorker, start_date, end_date)
  end
end
