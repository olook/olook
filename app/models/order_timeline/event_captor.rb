# -*- encoding : utf-8 -*-
module OrderTimeline
	class EventCaptor

    attr_reader :type, :order

    def set_capture_mode(type)
      @type = type
    end

    def snapshot(order)
      @type.snapshot(order)
    end

	end
end