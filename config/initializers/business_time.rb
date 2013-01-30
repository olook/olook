BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferris!
BusinessTime::Config.beginning_of_workday = "10:00 am"
BusinessTime::Config.end_of_workday = "11:30 am"

begin
  Holiday.all.each do |holiday|
    BusinessTime::Config.holidays << holiday.event_time.to_date
  end
rescue
end
