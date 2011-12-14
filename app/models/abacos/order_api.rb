# -*- encoding : utf-8 -*-
module Abacos
  class OrderAPI
    extend Helpers

    @queue = :abacos

    def self.wsdl
      "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSPedidos.asmx?wsdl"
    end
    
    def self.insert_order(order)
      payload = order.parsed_data
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :inserir_pedido, payload)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        true
      else
        error_container = response[:rows][:dados_pedidos_resultado][:resultado] || response[:resultado_operacao]
        raise_webservice_error error_container
      end
    end
    
    def self.confirm_order(protocol)
    end
    
    def self.download_orders_status
    end

    def self.order_exists?(order_number)
      payload = {'ListaDeNumerosDePedidos' => {'string' => order_number}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :pedido_existe, payload)
      error_container = response[:rows][:dados_pedidos_existentes][:existente]
    end

    def self.confirm_payment(payment)
      payload = {'ListaDePagamentos' => {'DadosPgtoPedido' => payment.parsed_data}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY

      response = call_webservice(wsdl, :confirmar_pagamentos_pedidos, payload)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        true
      else
        error_container = response[:rows][:dados_pgto_pedido_resultado][:resultado] || response[:resultado_operacao]
        raise_webservice_error error_container
      end
    end

    def self.cancel_order(cancelation)
      payload = {'ListaDePagamentos' => {'DadosPgtoPedido' => cancelation.parsed_data}}
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY

      response = call_webservice(wsdl, :confirmar_pagamentos_pedidos, payload)
      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        true
      else
        error_container = response[:rows][:dados_pgto_pedido_resultado][:resultado] || response[:resultado_operacao]
        raise_webservice_error error_container
      end
    end
  end
end
