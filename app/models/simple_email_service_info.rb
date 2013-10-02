class SimpleEmailServiceInfo < ActiveRecord::Base
  attr_accessible :bounces, :complaints, :delivery_attempts, :rejects, :sent
  scope :between_date, ->(initial_date,final_date) {where(sent: (initial_date)..final_date) }

  def self.info(initial_date,final_date)
    email_info_range = between_date(initial_date,final_date)
    collect_email_info(email_info_range)
  end

  private
  def self.collect_email_info(email_infos)
    Hash[ [:bounces,:complaints,:delivery_attempts,:rejects].map{ |k| [k, email_infos.inject(0){|sum, info| sum + info.send(k)}] } ]
  end
end
