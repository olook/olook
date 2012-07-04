# -*- encoding : utf-8 -*-
module OrderTimeline
  class EventBuilder

    attr_accessor :event, :order, :event_captor

    def initialize(event, order)
      @event = event
      @order = order
      @event_captor = EventCaptor.new
    end

    def capture_state(state_type, order)
      @event_captor.set_capture_mode(state_type)
      event.text = @event_captor.snapshot(order)
    end

    def set_headline(headline)
      event.headline = headline
    end

    def set_start_date(start_date)
      event.start_date = start_date
    end

  end
end