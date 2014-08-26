class ClearUnusedSessionsWorker
  @queue = 'low'
  def self.perform(period_end = DateTime.now - 60.days, period_start = DateTime.now - 61.days)
    if period_start < period_end
      sql = "DELETE FROM sessions WHERE (updated_at < '#{period_end.end_of_day}'"
      sql += " AND updated_at  >= '#{period_start.beginning_of_day}'"
      sql += ")"

      ActiveRecord::Base.connection.execute(sql)

      send_notification period_start
    end
  end

  private
    def self.send_notification starting_date
      UnusedSessionsMailer.send_notification(starting_date).deliver
    end
end
