# -*- encoding : utf-8 -*-
module OrderTimeline
  module Snapshot
	 class WaitingPayment
      
    include OrderTimeline::Helper
    
      def snapshot(order)
        "<h4>Atualização recebida as <b>#{format_time(order.updated_at)}</b></h4>
        <img src='/assets/order_timeline/moip.png' width='75px'>
        <ul style='font-size:14px'>
            <li>Envio da transação: <b>#{order.payment.payment_response.response_status}</b></li>
            <li>Situação: <b>#{order.payment.payment_response.status}</b></li>
            <li>Código Moip: <b>#{order.payment.payment_response.gateway_code}</b>
            <li>Gateway Fee: <b>#{order.payment.payment_response.gateway_fee.to_s}</b>
            <li>Código de identificação: <b>#{order.identification_code}</b></li>
            <li>Final do cartão: <b>#{order.payment.credit_card_number if order.payment.type == "CreditCard"}</b></li>
            <li>Telefone do cliente: <b>#{order.payment.telephone}</li>
            <li>CPF: <b>#{order.user.cpf}</b></li>
        </ul>
        <br/>
        #{shipping_service_art(order)}      
          <ul style='font-size:14px'>
            <li>Custo do frete: <b>R$ #{order.freight.cost.to_s}</b></li>
            <li>Receita de frete: <b>R$ #{order.freight.price.to_s}</b></li>
          </ul>"
      end
	 end
  end
end