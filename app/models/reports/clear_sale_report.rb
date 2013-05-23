class ClearSaleReport

  def initialize(start_date, end_date, admin)
    @start_date = parse start_date
    @end_date = parse end_date
    @admin = admin
  end

  def schedule_generation
    Resque.enqueue(ClearSaleReportWorker, @start_date, @end_date, @admin.email)
  end

  private

    def parse date
      date.to_a.sort.collect{|c| c[1]}.join("-")
    end
end
