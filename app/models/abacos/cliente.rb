# -*- encoding : utf-8 -*-
module Abacos
  class Cliente
    extend ::Abacos::Helpers
    
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
        @tipo_local_entrega = 'tleeResidencial'
        @pais               = 'Brasil'
      end
      
      def parsed_data
        {
          'Logradouro'          => self.logradouro,
          'NumeroLogradouro'    => self.numero,
          'ComplementoEndereco' => self.complemento,
          'Bairro'              => self.bairro,
          'Municipio'           => self.municipio,
          'Estado'              => self.estado,
          'Cep'                 => self.cep,
          'TipoLocalEntrega'    => self.tipo_local_entrega,
          'Pais'                => self.pais
        }
      end
    private
      def parse_cep(zip_code)
        zip_code.gsub(/-|\s/, '')[0..7]
      end
    end

    attr_reader :codigo, :tipo_pessoa, :sexo, :cpf, :email,
                :nome, :data_nascimento, :telefone, :data_cadastro,
                :endereco, :endereco_cobranca, :endereco_entrega

    def initialize(member, address)
      @codigo             = member.id.to_s
      @tipo_pessoa        = 'tpeFisica'
      @sexo               = 'tseFeminino'
      @cpf                = parse_cpf(member.cpf)
      @email              = member.email
      @nome               = "#{member.first_name} #{member.last_name}"
      @data_nascimento    = parse_data(member.birthday)
      @telefone           = parse_telefone(address.telephone)
      @data_cadastro      = parse_data(member.created_at)
      @endereco           = parse_endereco(address)
      @endereco_entrega   = @endereco
      @endereco_cobranca  = @endereco
    end
    
    def parsed_data
      {
        'ListaDeClientes' => {
          'DadosClientes' => {
            'Codigo'          => self.codigo,
            'TipoPessoa'      => self.tipo_pessoa,
            'Sexo'            => self.sexo,
            'CPFouCNPJ'       => self.cpf,
            'EMail'           => self.email,
            'Nome'            => self.nome,
            'DataNascimento'  => self.data_nascimento,
            'Telefone'        => self.telefone,
            'DataCadastro'    => self.data_cadastro,
            'Endereco'        => self.endereco.parsed_data
          }
        }
      }
    end
  private
    def parse_cpf(cpf)
      cpf.gsub(/-|\.|\s/, '')[0..10]
    end
    
    def parse_data(birthday)
      birthday.strftime "%d%m%Y"
    end
    
    def parse_telefone(telephone)
      telephone[0..14]
    end
    
    def parse_endereco(address)
      Endereco.new(address)
    end
  end
end
