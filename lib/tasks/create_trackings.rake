namespace :trackings do
  desc "Create trackings from events table"
  task :create => :environment do
    Event.where(:event_type => EventType::TRACKING).find_each do |e|
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
