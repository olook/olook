namespace :trackings do
  desc "Create trackings from events table"
  task :create, [:id] => :environment do |t, args|
    starting_id = args[:id] || 0
    Event.where("event_type = :tracking and id > :id", :tracking => EventType::TRACKING, :id => starting_id).find_each do |e|
      description = eval e.description
      Tracking.create!(:user_id => e.user_id,
                      :utm_source => description["utm_source"],
                      :utm_medium => description["utm_medium"],
                      :utm_content => description["utm_content"],
                      :utm_campaign => description["utm_campaign"],
                      :placement => description["placement"],
                      :gclid => description["gclid"],
                      :created_at => e.created_at
                      )
      end
    end
  end
