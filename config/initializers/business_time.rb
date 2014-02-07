BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

begin
  Holiday.all.each do |holiday|
    BusinessTime::Config.holidays << holiday.event_date.to_date
  end
rescue
end
