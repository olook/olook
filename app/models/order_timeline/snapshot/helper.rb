# -*- encoding : utf-8 -*-
module OrderTimeline
  module Snapshot
    module Helper
  		
      include OrderHelper
  		include OrderTimeline::Helper
      
      def format_time(date)
        date.to_datetime.strftime("%H:%M:%S")
      end

      def shipping_service_art(order)
        case order.freight.shipping_service.erp_code
          when "TEX"
            "<img src='/assets/order_timeline/total-express.jpg' width='75px'>"
          when "PAC"
            "<img src='/assets/order_timeline/correios.png' width='75px'>"
        end
      end
      
    end
  end
end