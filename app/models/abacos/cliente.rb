# -*- encoding : utf-8 -*-
module Abacos
  class Cliente
    include ::Abacos::Helpers
    
    attr_reader :codigo, :tipo_pessoa, :sexo, :cpf, :email,
                :nome, :data_nascimento, :telefone, :celular, :data_cadastro,
                :endereco, :endereco_cobranca, :endereco_entrega

    def initialize(member, address)
      @codigo             = "F#{member.id}"
      @tipo_pessoa        = member.reseller_without_cpf? ? 'tpeJuridica' : 'tpeFisica'
      @sexo               = 'tseFeminino'
      @cpf                = member.reseller_without_cpf? ? parse_cnpj(member.cnpj) : parse_cpf(member.cpf)
      @email              = member.email
      @nome               = "#{member.first_name} #{member.last_name}"
      @data_nascimento    = parse_data(member.birthday)
      @telefone           = parse_telefone(address.telephone)
      @celular            = parse_celular(address.mobile)
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
            'Celular'         => self.celular,
            'DataCadastro'    => self.data_cadastro,
            'Endereco'        => self.endereco.parsed_data
          }
        }
      }
    end
  end
end
