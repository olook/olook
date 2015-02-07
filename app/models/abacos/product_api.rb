# -*- encoding : utf-8 -*-
module Abacos
  class ProductAPI
    class ProductAPIError < StandardError; end
    extend Helpers

    def self.wsdl
      ABACOS_CONFIG["wsdl_product_api"]
    end

    def self.download_products
      download_xml :produtos_disponiveis, :dados_produtos
    end

    def self.download_inventory
      download_xml :estoques_disponiveis, :dados_estoque
    end

    def self.download_prices
      download_xml :precos_disponiveis, :dados_preco
    end

    def self.download_online_inventory(product_number_list=[])
      result = {}
      path = ABACOS_CONFIG["wsdl_product_api"].dup.gsub('?wsdl', '')
      path += "/EstoqueOnLine?ChaveIdentificacao=#{ABACOS_CONFIG['key']}"

      product_list = product_number_list.map { |number| "ListaDeCodigosProdutos=#{number}" }

      get_path = path.dup
      results = {}
      product_list.each do |product_path|
        get_path += "&#{product_path}"
        if get_path.size > 1800
          results.merge!(get_online_inventory(get_path))
          get_path = path.dup
        end
      end
      if get_path.size > path.size
        results.merge!(get_online_inventory(get_path))
      end
      results
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

    def self.get_online_inventory(path)
      Rails.logger.info("GET #{path}")
      uri = URI.parse(path)
      response = Net::HTTP.get_response(uri)
      Rails.logger.debug(response.body)
      xml_doc  = Nokogiri::XML(response.body)
      inventory_result = xml_doc.css('DadosEstoqueResultado')
      raise ProductAPIError.new("NotFound Results, maybe products don't exist on Abacos? GET #{path}\nresponse body:\n#{response.body}") if inventory_result.size == 0
      results = inventory_result.inject({}) do |h, node|
        h[node.css('CodigoProduto').text] = node.css('SaldoDisponivel').text
        h
      end
      results
    end

    def self.confirm_integration(method, protocol)
      parsed_method = "confirmar_recebimento_#{method}".to_sym
      response = call_webservice(wsdl, parsed_method, {"Protocolo#{method.to_s.capitalize}" => protocol})
      return true if response[:tipo] == 'tdreSucesso'
      raise_webservice_error(response)
    end
  end
end
