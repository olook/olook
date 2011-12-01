# -*- encoding : utf-8 -*-
module Abacos
  module Helpers
    API_KEY = "D0D9B9D4-827B-47B5-9CA2-475E13DCBA64"

    def find_in_descritor_pre_definido(data, query)
      items = parse_nested_data(data, :dados_descritor_pre_definido)

      items.each do |item|
        return item[:descricao].strip if item[:grupo_nome].strip == query
      end
      ''
    end

    def parse_category(abacos_category)
      case abacos_category.strip.downcase
        when 'sapato' then Category::SHOE
        when 'bolsa' then Category::BAG
        when 'jóia' then Category::JEWEL
      else
        Category::SHOE
      end
    end

    def call_webservice(wsdl, method, params = { "ChaveIdentificacao" => API_KEY })
      client = Savon::Client.new wsdl
      client.http.read_timeout = 3000
      xml = client.request :abac, method, :body => params
      
      response = xml.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym]
      
      raise_webservice_error(response) if response[:resultado_operacao].nil?

      response
    end
    
    def raise_webservice_error(response)
      raise "Error calling webservice #{response[:method]}: (#{response[:codigo]}) #{response[:tipo]} - #{response[:descricao]} - #{response[:exception_message]}"
    end
    
    # The Abacos API may return invalid nested data inside a valid response
    def parse_nested_data(data, key)
      call_response = data[:resultado_operacao][:tipo]
      
      case call_response
        when 'tdreSucesso'
          parsed_data = data[:rows][key]
          parsed_data = [parsed_data] unless parsed_data.is_a? Array
          return parsed_data.compact
        when 'tdreSucessoSemDados'
          return []
      else
        raise "Nested data \"#{data}\" is invalid"
      end
    end
  end
end
