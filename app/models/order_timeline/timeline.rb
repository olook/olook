module OrderTimeline

  class Timeline

    include OrderTimeline::Helper

    attr_accessor :headline, :start_date, :text, :type, :events

  	def initialize
     @events = []
  	end

  end
end
