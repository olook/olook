module OrderTimeline
  class TimelineTrack < ActiveRecord::Base
    
    serialize :timeline_track, Hash


    def self.serialize_as_hash_with_js_notation(timeline)
      events = []
      timeline.events.each do |e|
        events << {:startDate => e.start_date, :headline => e.headline, :text => e.text}.clone
      end
      {:timeline => {:startDate => timeline.start_date, :text => timeline.text, :type => timeline.type, :headline => timeline.headline, :date => events}}
    end

    def unserialize_as_timeline_object
      timeline = Timeline.new
      timeline.start_date = self.timeline[:timeline][:startDate]
      timeline.text = self.timeline[:timeline][:text]
      timeline.headline = self.timeline[:timeline][:headline]
      timeline.type = self.timeline[:timeline][:type]
      self.timeline[:timeline][:date].each do |event|
        timeline.events << Event.new(event[:startDate], event[:headline], event[:text])
      end
      timeline
    end

  end
end