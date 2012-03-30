namespace :trackings do
  desc "Create trackings from events table (starting from the given event first_id and last_id)"
  task :create, [:first_id, :last_id] => :environment do |t, args|
    first_id = args[:first_id] || 0
    last_id = args[:last_id] || Event.last.id
    Event.where("event_type = :tracking and id > :first_id and id < :last_id",
                :tracking => EventType::TRACKING,
                :first_id => first_id,
                :last_id  => last_id).find_each do |e|
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
