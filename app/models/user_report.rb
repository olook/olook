# -*- encoding : utf-8 -*-
module UserReport
  def self.statistics
    User.select("date(created_at) as creation_date, count(id) as daily_total").group("date(created_at)")
  end
end
