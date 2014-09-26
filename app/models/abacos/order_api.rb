# -*- encoding : utf-8 -*-
module Abacos
  class OrderAPI
    extend Helpers

    def self.wsdl
      ABACOS_CONFIG["wsdl_order_api"]
    end

    def self.insert_order(order)
      return true unless Setting.abacos_integrate

      payload = order.parsed_data
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :inserir_pedido, payload)
      order = Order.find_by_number(order.numero)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        order.update_attribute(:erp_integrate_at, DateTime.now)
        true
      else
        error_container = response[:rows][:dados_pedidos_resultado][:resultado][:exception_message] || response[:resultado_operacao]
        order.update_attribute(:erp_integrate_error, error_container)
        # raise_webservice_error error_container
        raise "Erro ao inserir o pedido:#{order.number},erro:#{error_container}"
      end
    end

    def self.confirm_order_status(protocol)
      response = call_webservice(wsdl, :confirmar_recebimento_status_pedido, {"ProtocoloStatusPedido" => protocol})
      if response[:tipo] == 'tdreSucesso'
        true
      else
        raise_webservice_error(response)
      end
    end

    def self.download_orders_statuses
      download_xml :status_pedido_disponiveis, :dados_status_pedido
    end

    def self.order_exists?(order_number)
      payload = {'ListaDeNumerosDePedidos' => {'string' => order_number}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :pedido_existe, payload)
      error_container = response[:rows][:dados_pedidos_existentes][:existente]
    end

    def self.confirm_payment(payment)
      return true unless Setting.abacos_integrate

      payload = {'ListaDePagamentos' => {'DadosPgtoPedido' => payment.parsed_data}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      order = Order.find_by_number(payment.numero_pedido)

      response = call_webservice(wsdl, :confirmar_pagamentos_pedidos, payload)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        order.update_attribute(:erp_payment_at, DateTime.now)
        true
      else
        error_container = response[:rows][:dados_pgto_pedido_resultado][:resultado] || response[:resultado_operacao]
        order.update_attribute(:erp_payment_error, error_container)
        raise_webservice_error error_container
      end
    end

    def self.cancel_order(cancelation)
      return true unless Setting.abacos_integrate
      
      payload = {'ListaDePagamentos' => {'DadosPgtoPedido' => cancelation.parsed_data}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      order = Order.find_by_number(cancelation.numero_pedido)

      response = call_webservice(wsdl, :confirmar_pagamentos_pedidos, payload)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        true
        order.update_attribute(:erp_cancel_at, DateTime.now)
      else
        error_container = response[:rows][:dados_pgto_pedido_resultado][:resultado] || response[:resultado_operacao]
        order.update_attribute(:erp_cancel_error, error_container)
        raise_webservice_error error_container
      end
    end
  end
end
