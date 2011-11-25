# -*- encoding : utf-8 -*-
module Abacos
  class DownloadProducts
    @queue = :abacos

  private
    def self.download_products
      client = Savon::Client.new "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSProdutos.asmx?wsdl"
      xml = client.request :abac, :produtos_disponiveis, :body => { "ChaveIdentificacao" => "D0D9B9D4-827B-47B5-9CA2-475E13DCBA64" }
      xml.to_hash[:produtos_disponiveis_response][:produtos_disponiveis_result][:rows][:dados_produtos]
    end
  end
end
