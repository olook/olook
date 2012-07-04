# -*- encoding : utf-8 -*-
module OrderTimeline
  module Snapshot
	 class Picking
      
    include OrderTimeline::Helper

    def snapshot(order)
      "<h4>Atualização recebida as <b>#{format_time(order.updated_at)}</b></h4>
        <img src='/assets/order_timeline/completa.jpg' width='75px'>
        <ul style='font-size:14px'>
          <li>Situação: <b>#{order.status}</b></li>
        </ul>"
    end
  
    end
  end
end