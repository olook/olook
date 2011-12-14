# -*- encoding : utf-8 -*-

class MarketingReport

  def generate_csv
    CSV.generate do |csv|
      csv << ["id", "first_name", "last_name"]
      User.all.each do |user|
        csv << [user.id, user.first_name, user.last_name]
      end
    end
  end

end