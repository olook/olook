# -*- encoding : utf-8 -*-
module Abacos
  class ClientAPI
    extend Helpers

    @queue = :abacos
    
    def self.wsdl
      "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSClientes.asmx?wsdl"
    end
    
    def self.export_client(client)
      payload = client.parsed_data
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :cadastrar_cliente, payload)
      response[:resultado_operacao][:tipo] == 'tdreSucesso' ? true : raise_webservice_error(response[:resultado_operacao])
    end
  end
end
