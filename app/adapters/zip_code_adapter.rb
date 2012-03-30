# -*- encoding : utf-8 -*-
require 'net/http'  
require 'cgi'

class ZipCodeAdapter
  def self.get_address(zipcode)
    url = URI.parse("http://cep.republicavirtual.com.br/web_cep.php?cep=#{zipcode}&formato=query_string")
    Rails.logger.info url
    query = Net::HTTP.get_response(url)
    result = CGI::parse(query.body)

    # o CGI::parse retorna um hash cujos valores são arrays de um elemento só.  
    # para facilitar tratamento posterior vamos retirar os valores destes arrays  
    # exemplo:  'tipo_logradouro' => ['Rua']  vira  'tipo_logradouro' => 'Rua'
    result = Hash[*result.map { |k, v| [k, v[0].force_encoding("ISO-8859-1").encode("UTF-8")] }.flatten]

    case result['resultado'].to_i
      when 1 then
        {
          :result_type => result['resultado'],
          # :address_type => result['tipo_logradouro'],
          :street => result['logradouro'],
          :neighborhood => result['bairro'],
          :city => result['cidade'],
          :state => result['uf']
        }
      when 2 then
        {
          :result_type => result['resultado'],
          :city => result['cidade'],
          :state => result['uf']
        }
      else
        {
          :result_type => result['resultado'],
        }
    end
  end
  
end