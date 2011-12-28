# -*- encoding : utf-8 -*-
module UserReport
  def self.generate_csv
    attributes = [:first_name, :last_name, :email, :cpf, :is_invited, :created_at]
    file_name = "users-#{Time.now.strftime("%Y-%m-%d_%H-%M")}.csv"

    CSV.open(Rails.root.join("public", "admin", file_name), "w") do |csv|
      # CSV header
      csv << attributes.collect { |attr| attr.to_s.titleize }

      User.select(attributes).find_each do |user|
        csv << attributes.collect { |attr| user.send(attr) }
      end
    end

    file_name
  end

  def self.statistics
    User.select("date(created_at) as creation_date, count(id) as daily_total").group("date(created_at)")
  end
end
