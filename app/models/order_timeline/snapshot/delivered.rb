# -*- encoding : utf-8 -*-
module OrderTimeline
  module Snapshot
	 class Delivered
      
    include OrderTimeline::Helper

    def snapshot(order)
      "<h4>Atualização recebida as <b>#{format_time(order.updated_at)}</b></h4>"      
    end
  
    end
  end
end