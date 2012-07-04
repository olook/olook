# -*- encoding : utf-8 -*-
module OrderTimeline
	class Event
		
    attr_accessor :headline, :text, :start_date

    def initialize(start_date, headline, text)
      @start_date = start_date
      @headline = headline
      @text = text
    end

	end
end