# -*- encoding : utf-8 -*-
module OrderTimeline
	class Notifier

    def self.notify_event(order)
      if self.is_valid_tracking_state?(order.state)
        timeline = TimelineTrack.find_by_order_id(order.id)
        timeline = timeline.nil? ? Timeline.new : timeline.unserialize_as_timeline_object
        tc = TimelineConstructor.new(timeline, order)
        tc.construction_method(order.state)
      end
    end

    def self.is_valid_tracking_state?(state)
      case state
        when "waiting_payment"
          return true
        when "authorized"
          return true
        when "picking"
          return true
        when "delivering"
          return true
        when "delivered"
          return true
      end
    end

	end
end