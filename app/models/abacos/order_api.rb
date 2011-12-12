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
      response[:resultado_operacao][:tipo] == 'tdreSucesso' ? true : raise_webservice_error(response[:resultado_operacao])
    end
    
    def self.confirm_order(protocol)
    end
    
    def self.download_orders_status
    end

    def self.order_exists?(order)
    end

    def self.pay_order(order)
    end
  end
end
