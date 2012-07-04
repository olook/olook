# -*- encoding : utf-8 -*-
module OrderTimeline
  module Snapshot
	 class Delivering
    
    include OrderTimeline::Helper
      
      def snapshot(order)
        "<h4>Atualização recebida as <b>#{format_time(order.updated_at)}</b></h4>
          #{shipping_service_art(order)}      
          <ul style='font-size:13px'>
            <li>Tracking code: #{link_to_tracking_code(order)}</li>
          </ul>"
      end

    end
	end
end