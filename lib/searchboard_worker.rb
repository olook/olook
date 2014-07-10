class SearchboardWorker
  @queue = 'low'

  def self.perform 
    report = Searchboard.new.print_report
    DevAlertMailer.searchboard_report(report).deliver!

    Searchboard.clear
  end

end