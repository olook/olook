# -*- encoding : utf-8 -*-
module Abacos
  class ProductAPI
    extend Helpers

    @queue = :abacos
    
    WSDL = "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSProdutos.asmx?wsdl"

    def self.download_products
      download_xml :produtos_disponiveis, :dados_produtos
    end

    def self.download_inventory
      download_xml :estoques_disponiveis, :dados_estoque
    end

    def self.download_prices
      download_xml :precos_disponiveis, :dados_preco
    end
    
    def self.confirm_product(protocol)
      confirm_integration :produto, protocol
    end

    def self.confirm_inventory(protocol)
      confirm_integration :estoque, protocol
    end

    def self.confirm_price(protocol)
      confirm_integration :preco, protocol
    end
  private
    def self.confirm_integration(method, protocol)
      #parsed_method = "confirmar_recebimento_#{method}".to_sym
      #response = call_webservice(WSDL, parsed_method, {"Protocolo#{method.to_s.capitalize}" => protocol})
      #response[:tipo] == 'tdreSucesso' ? true : raise_webservice_error(response)
      true
    end

    def self.download_xml(method, data_key)
      data = call_webservice(WSDL, method)[data_key]
      data.is_a?(Array) ? data : [data]
    end
  end
end
