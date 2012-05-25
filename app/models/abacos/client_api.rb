# -*- encoding : utf-8 -*-
module Abacos
  class ClientAPI
    extend Helpers

    def self.wsdl
      ABACOS_CONFIG["wsdl_client_api"]
    end

    def self.export_client(client)
      payload = client.parsed_data
      payload["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      response = call_webservice(wsdl, :cadastrar_cliente, payload)

      if response[:resultado_operacao][:tipo] == 'tdreSucesso'
        true
      else
        error_container = response[:rows][:dados_clientes_resultado][:resultado] || response[:resultado_operacao]
        raise_webservice_error error_container
      end
    end
  end
end
