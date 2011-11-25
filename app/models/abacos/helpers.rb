# -*- encoding : utf-8 -*-
module Abacos
  module Helpers
    API_KEY = "D0D9B9D4-827B-47B5-9CA2-475E13DCBA64"

    def find_in_descritor_pre_definido(data, query)
      items = data[:rows][:dados_descritor_pre_definido]
      
      items = [items] unless items.is_a? Array
      
      items.each do |item|
        return item[:descricao].strip if item[:grupo_nome].strip == query
      end
      ''
    end

    def parse_category(abacos_category)
      case abacos_category.strip
        when 'Sapato' then Category::SHOE
        when 'Bolsa' then Category::BAG
        when 'Jóia' then Category::JEWEL
      else
        Category::SHOE
      end
    end

    def call_webservice(wsdl, method, params = { "ChaveIdentificacao" => API_KEY })
      client = Savon::Client.new wsdl
      xml = client.request :abac, method, :body => params
      
      response = xml.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym]
      if response[:resultado_operacao].nil?
        raise_webservice_error(response)
      else
        data = response[:rows]
      end
    end
    
    def raise_webservice_error(response)
      raise "Error calling webservice #{response[:method]}: (#{response[:codigo]}) #{response[:tipo]} - #{response[:descricao]} - #{response[:exception_message]}"
    end
  end
end
