# -*- encoding : utf-8 -*-
module Abacos
  module Helpers
    API_KEY = ABACOS_CONFIG["key"]

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
        when 'joia' then Category::ACCESSORY
        when 'jóia' then Category::ACCESSORY
        when 'lingerie' then Category::LINGERIE
        when 'moda praia' then Category::BEACHWEAR
      else
        Category::CLOTH
      end
    end

    def call_webservice(wsdl, method, params = { "ChaveIdentificacao" => API_KEY })
      client = Savon::Client.new wsdl
      client.http.read_timeout = 3000
      xml = client.request :abac, method, :body => params

      response = xml.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym]

      # TODO: refactor method to make this response check optional
      # raise_webservice_error(response) if response[:resultado_operacao].nil?

      response
    end

    def raise_webservice_error(response)
      #TODO: raise more descriptive error when there's lack of inventory in abacos
      #this happens frequently on dev and homolog servers, since the db isn't in sync with abacos there:
      #   Error calling webservice : (300005) tdreErroDataBase - A execução da rotina gerou uma crítica. Detalhes: * Origem: Incluir itens no pedido * Linha em que ocorreu o erro: 36 * Nome do objeto onde ocorreu o erro: PGEN_P_RAISERROR * Código de erro do banco de dados: 88104 - Interface = 4 Pedido = 2656332 Produto = 13767 Msg = produto não cadastrado Erro ao cadastrar itens
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

    def download_xml(method, data_key)
      data = call_webservice(self.wsdl, method)
      parse_nested_data data, data_key
    end

    def parse_cpf(cpf)
      cpf.gsub(/-|\.|\s/, '')[0..10] unless cpf.nil?
    end

    def parse_cnpj cnpj 
      cnpj.gsub(/(\.|\/|-)/, "") unless cnpj.nil?
    end

    def parse_data(birthday)
      return "01011900"  if birthday.nil? # TODO: Emergency fix , should be replaced!
      birthday.strftime "%d%m%Y"
    end

    def parse_datetime(datetime)
      datetime.strftime "%d%m%Y %H:%M:%S"
    end

    def parse_telefone(telephone)
      telephone[0..14] if telephone
    end

    def parse_celular(mobile)
      mobile[0..14] if mobile
    end

    def parse_price(price)
      "%.2f" % (price || 0)
    end

    def parse_endereco(address)
      Abacos::Endereco.new(address)
    end

  end
end
