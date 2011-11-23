# -*- encoding : utf-8 -*-
module UserReport
  def self.export
    User.all.map do |user|
      [ user.first_name,
        user.last_name,
        user.email,
        user.is_invited? ? 'invited' : 'organic',
        user.created_at.to_s(:short),
        user.profile_scores.first.try(:profile).try(:name),
        user.invitation_url,
        user.events.where(:event_type => EventType::TRACKING).first.try(:description)
      ]
    end
  end
  
  def self.statistics
    User.select("date(created_at) as creation_date, count(id) as daily_total").group("date(created_at)")
  end
end
