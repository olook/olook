# -*- encoding : utf-8 -*-

# Altough it is a bad design, the text value mixes html with data, to match
# the Timeline JS Json format http://timeline.verite.co/#fileformat

module OrderTimeline
  module Snapshot
    class Authorized
      
      include OrderTimeline::Helper

      def snapshot(order)
        "<h4>Atualização recebida as <b>#{format_time(order.updated_at)}</b></h4>
          <img src='/assets/order_timeline/moip.png' width='75px'>
          <ul style='font-size:14px'>
            <li>Situação: <b>#{order.payment.payment_response.status}</b></li>
            <li>Classificação: <b>#{order.payment.gateway_status_reason}</b></li>
          </ul>
          #{shipping_service_art(order)}      
          <ul style='font-size:14px'>
            <li>Data estimada de entrega: <b>#{calculate_delivered_date(order.payment.updated_at, order.freight.delivery_time)}</b></li>
          </ul>"
      end
    end
  end
end