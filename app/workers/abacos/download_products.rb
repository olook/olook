# -*- encoding : utf-8 -*-
module Abacos
  class DownloadProducts
    @queue = :abacos
    
    WSDL = "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSProdutos.asmx?wsdl"
    API_KEY = "D0D9B9D4-827B-47B5-9CA2-475E13DCBA64"

  private
    def self.download_products
      download_xml :produtos_disponiveis, :dados_produtos
    end

    def self.download_inventory
      download_xml :estoques_disponiveis, :dados_estoque
    end

    def self.download_prices
      download_xml :precos_disponiveis, :dados_preco
    end
    
    def self.download_xml(method, data_key)
      client = Savon::Client.new WSDL
      xml = client.request :abac, method, :body => { "ChaveIdentificacao" => API_KEY }
      data = xml.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym][:rows][data_key]
      data.is_a?(Array) ? data : [data]
    end
  end
end
