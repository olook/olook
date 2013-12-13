# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Cliente do
  let(:member)  { FactoryGirl.create :member,
                    :cpf => '98765432198', :birthday => Date.civil(1980,5,15),
                    :email => 'janedoe@test.com', :first_name => 'Jéssica', :last_name => 'Maíra'
                }
  let(:address) { FactoryGirl.create :address }
  subject { described_class.new member, address }

  describe 'attributes' do
    it '#codigo' do
      subject.codigo.should == "F#{member.id}"
    end

    it '#tipo_pessoa' do
      subject.tipo_pessoa.should == 'tpeFisica'
    end

    it '#sexo' do
      subject.sexo.should == 'tseFeminino'
    end

    it '#cpf' do
      subject.cpf.should == '98765432198'
    end

    it '#email' do
      subject.email.should == 'janedoe@test.com'
    end

    it '#nome' do
      subject.nome.should == 'Jéssica Maíra'
    end

    it '#data_nascimento' do
      subject.data_nascimento.should == '15051980'
    end

    it '#telefone' do
      subject.telefone.should == '(35)3712-3457'
    end

    it '#data_cadastro' do
      subject.data_cadastro.should == member.created_at.strftime("%d%m%Y")
    end

    describe '#endereco' do
      it '#logradouro' do
        subject.endereco.logradouro.should == 'Rua Exemplo Teste'
      end
      it '#numero_logradouro' do
        subject.endereco.numero.should == '12354'
      end
      it '#complemento_endereco' do
        subject.endereco.complemento.should == 'ap 45'
      end
      it '#bairro' do
        subject.endereco.bairro.should == 'Centro'
      end
      it '#municipio' do
        subject.endereco.municipio.should == 'Rio de Janeiro'
      end
      it '#estado' do
        subject.endereco.estado.should == 'RJ'
      end
      it '#cep' do
        subject.endereco.cep.should == '87656908'
      end
      it '#tipo_local_entrega' do
        subject.endereco.tipo_local_entrega.should == 'tleeDesconhecido'
      end
      it '#pais' do
        subject.endereco.pais.should == 'Brasil'
      end
    end

    it '#endereco_cobranca should be the same as #endereco' do
      subject.endereco_cobranca.should == subject.endereco
    end
    it '#endereco_entrega should be the same as #endereco' do
      subject.endereco_entrega.should == subject.endereco
    end
  end

  describe '#parsed_data' do
    let(:expected_parsed_data) {
            {
            'ListaDeClientes' => {
              'DadosClientes' => {
                  'Codigo' => "F#{member.id}",
                  'TipoPessoa'=> 'tpeFisica',
                  'Sexo' => 'tseFeminino',
                  'CPFouCNPJ' => '98765432198',
                  'EMail' => 'janedoe@test.com',
                  'Nome' => 'Jéssica Maíra',
                  'DataNascimento' => '15051980',
                  'Telefone' => '(35)3712-3457',
                  'Celular' => '(21)99876-2737',
                  'DataCadastro' => member.created_at.strftime("%d%m%Y"),
                  'Endereco' => {
                        'Logradouro' => 'Rua Exemplo Teste',
                        'NumeroLogradouro' => '12354',
                        'ComplementoEndereco' => 'ap 45',
                        'Bairro' => 'Centro',
                        'Municipio' => 'Rio de Janeiro',
                        'Estado' => 'RJ',
                        'Cep' => '87656908',
                        'TipoLocalEntrega' => 'tleeDesconhecido',
                        'Pais' => 'Brasil'
                  }
                }
              }
            }
    }

    it 'should be a hash with the proper keys and values for export' do
      subject.parsed_data.should == expected_parsed_data
    end
  end
end
