module Abacos
  class Endereco
    attr_reader :logradouro, :numero, :complemento, :bairro, :municipio,
                :estado, :cep, :tipo_local_entrega, :pais

    def initialize(address)
      @logradouro         = address.street
      @numero             = address.number.to_s
      @complemento        = address.complement
      @bairro             = address.neighborhood
      @municipio          = address.city
      @estado             = address.state
      @cep                = parse_cep(address.zip_code)
      @tipo_local_entrega = "tleeDesconhecido"
      @pais               = "Brasil"
    end
    
    def parsed_data(prefix = "")
      {
        "#{prefix}Logradouro"          => self.logradouro,
        "#{prefix}NumeroLogradouro"    => self.numero,
        "#{prefix}ComplementoEndereco" => self.complemento,
        "#{prefix}Bairro"              => self.bairro,
        "#{prefix}Municipio"           => self.municipio,
        "#{prefix}Estado"              => self.estado,
        "#{prefix}Cep"                 => self.cep,
        "#{prefix}TipoLocalEntrega"    => self.tipo_local_entrega,
        "#{prefix}Pais"                => self.pais
      }
    end
  private
    def parse_cep(zip_code)
      zip_code.gsub(/-|\s/, "")[0..7]
    end
  end
end
