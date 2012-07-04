# -*- encoding : utf-8 -*-
module OrderTimeline

  class TimelineBuilder

    include OrderTimeline::Helper

    attr_accessor :timeline, :order

    def initialize(timeline,order)
      @timeline = timeline
      @order = order
    end
    
    def set_headline
      @timeline.headline = "Histórico do pedido: #{order.number}"
    end

    def set_text
      @timeline.text = ""
    end

    def set_start_date
      @timeline.start_date = to_timeline_date_format(order.created_at)
    end

    def set_type
      @timeline.type = 'default'
    end

    def add_event(event)
      @timeline.events << event
    end

  end

end


