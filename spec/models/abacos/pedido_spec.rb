# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Pedido do
  let(:member)  { FactoryGirl.create :member,
                    :cpf => '98765432198',
                    :email => 'janedoe@test.com', :first_name => 'Jéssica', :last_name => 'Maíra'
                }
  let(:payment) { FactoryGirl.create :credit_card }
  let(:freight) { FactoryGirl.create :freight, :price => 22.0, :cost => 18.0, :delivery_time => 5 }
  let(:order) { FactoryGirl.create :clean_order, :user => member, :credits => 11.0, :payment => payment, :freight => freight, :created_at => Date.civil(2011, 12, 01) }
  let(:gift_order) { FactoryGirl.create :clean_order, :user => member, :credits => 11.0, :payment => payment, :freight => freight, :created_at => Date.civil(2011, 12, 01), :gift_wrapped => true, :gift_message => 'Mensagem para presente'  }
  let(:variant_a) { FactoryGirl.create :basic_shoe_size_35 }
  let(:variant_b) { FactoryGirl.create :basic_shoe_size_40 }
  let!(:line_item_1) { FactoryGirl.create :line_item, :order => order, :variant => variant_a, :quantity => 2, :price => 20.0 }
  let!(:line_item_2) { FactoryGirl.create :line_item, :order => order, :variant => variant_b, :quantity => 1, :price => 30.0 }


  context "creating a gift order" do

    describe "should have correct abacos gifties attributes" do
      let(:nota_simbolica) { true }
      let(:valor_embalagem) { YAML::load_file(Rails.root.to_s + '/config/gifts.yml')["values"][0] }
      let(:anotacao_pedido) { 'Mensagem para presente' }

      subject do
        described_class.new gift_order
      end

      it "should pass true to nota_simbolica" do
        subject.nota_simbolica.should == nota_simbolica
      end

      it "should enable EmitirNotaSimbolica" do
        subject.parsed_data['ListaDePedidos']['DadosPedidos']['EmitirNotaSimbolica'].should == nota_simbolica
      end

      it "should pass true to valor_embalagem" do
        subject.valor_embalagem.should == valor_embalagem
      end

      it "should enable ValorEmbalagemPresente" do
        subject.parsed_data['ListaDePedidos']['DadosPedidos']['ValorEmbalagemPresente'].should == valor_embalagem
      end

      it "should pass true to anotacao_pedido" do
        subject.anotacao_pedido.should == anotacao_pedido
      end

      it "should enable Anotacao1" do
        subject.parsed_data['ListaDePedidos']['DadosPedidos']['Anotacao1'].should == anotacao_pedido
      end

    end

  end

  context "when the order discount(coupom or credits) is greater then order total" do
    it "it should decrement the discount" do
     order.stub(:line_items_total).and_return BigDecimal.new("129.90")
     order.stub(:total_discount).and_return BigDecimal.new("130.0")
     pedido = described_class.new order
     pedido.valor_desconto.should == "124.90"
    end
  end

  context "when the order discount(coupom or credits) is not greater then order total" do

    subject do
      described_class.new order
    end

    describe 'attributes' do
      it '#numero' do
        subject.numero.should == order.number
      end

      it '#codigo_cliente' do
        subject.codigo_cliente.should == "F#{member.id}"
      end

      it '#cpf' do
        subject.cpf.should == '98765432198'
      end

      it '#nome' do
        subject.nome.should == 'Jéssica Maíra'
      end

      it '#email' do
        subject.email.should == 'janedoe@test.com'
      end

      it '#telefone' do
        subject.telefone.should == '(35)3712-3457'
      end

      it '#data_venda' do
        subject.data_venda.should == '01122011'
      end

      it '#valor_pedido' do
        subject.valor_pedido.should == '70.00'
      end

      it '#valor_desconto' do
        subject.valor_desconto.should == "11.00"
      end

      it '#valor_frete' do
        subject.valor_frete.should == '22.00'
      end

      it '#transportadora' do
        subject.transportadora.should == 'TEX'
      end

      it '#tempo_entrega' do
        subject.tempo_entrega.should == 5
      end

      describe '#itens' do
        it 'should have two items' do
          subject.itens.length.should == 2
        end
        describe 'first item' do
          let(:first_item) { subject.itens.first }

          it '#codigo' do
            first_item.codigo.should == variant_a.number
          end
          it '#quantidade' do
            first_item.quantidade.should == 2
          end
          it '#preco_unitario' do
            first_item.preco_unitario.should == '20.00'
          end
        end
      end

      describe 'endereco' do
        let(:endereco) { subject.endereco }
        it '#logradouro' do
          endereco.logradouro.should == 'Rua Exemplo Teste'
        end
        it '#numero_logradouro' do
          endereco.numero.should == '12354'
        end
        it '#complemento_endereco' do
          endereco.complemento.should == 'ap 45'
        end
        it '#bairro' do
          endereco.bairro.should == 'Centro'
        end
        it '#municipio' do
          endereco.municipio.should == 'Rio de Janeiro'
        end
        it '#estado' do
          endereco.estado.should == 'RJ'
        end
        it '#cep' do
          endereco.cep.should == '87656908'
        end
        it '#tipo_local_entrega' do
          endereco.tipo_local_entrega.should == 'tleeDesconhecido'
        end
        it '#pais' do
          endereco.pais.should == 'Brasil'
        end
      end

      describe 'pagamento' do
        let(:pagamento) { subject.pagamento }

        it '#valor' do
          pagamento.valor.should == '81.00'
        end
      end
    end

    describe '#parsed_data' do
      let(:expected_parsed_data) {
              {
                'ListaDePedidos' => {
                  'DadosPedidos' => {
                    'NumeroDoPedido' => order.number,
                    'CodigoCliente' => "F#{order.user.id}",
                    'CPFouCNPJ' => '98765432198',
                    'DataVenda' => '01122011',
                    'DestNome' => 'Jéssica Maíra',
                    'DestEmail' => 'janedoe@test.com',
                    'DestTelefone' => '(35)3712-3457',

                    'ValorPedido' => '70.00',
                    'ValorDesconto' => '11.00',
                    'ValorFrete' => '22.00',
                    'Transportadora' => 'TEX',
                    'PrazoEntregaPosPagamento' => 5,
                    'DataPrazoEntregaInicial' => "#{5.days.from_now.strftime("%d%m%Y")} 21:00",

                    'EmitirNotaSimbolica'     => false,
                    'ValorEmbalagemPresente'  => false,
                    'Anotacao1'               => false,

                    'Itens' =>  {
                      'DadosPedidosItem' => [
                                  {
                                      'CodigoProduto' => variant_a.number,
                                      'QuantidadeProduto' => 2,
                                      'PrecoUnitario' => '20.00',
                                      'PrecoUnitarioBruto' => '20.00',
                                      'EmbalagemPresente' => false
                                  },
                                  {
                                      'CodigoProduto' => variant_b.number,
                                      'QuantidadeProduto' => 1,
                                      'PrecoUnitario' => '30.00',
                                      'PrecoUnitarioBruto' => '30.00',
                                      'EmbalagemPresente' => false
                                  }
                                ] },
                    'FormasDePagamento' =>
                                {
                                  'DadosPedidosFormaPgto' => {
                                    'Valor'                 => '81.00',
                                    'CartaoQtdeParcelas'    => 1,
                                    'FormaPagamentoCodigo'  => 'VISA',
                                    'BoletoVencimento'  => nil
                                  }
                                },

                    'DestLogradouro' => 'Rua Exemplo Teste',
                    'DestNumeroLogradouro' => '12354',
                    'DestComplementoEndereco' => 'ap 45',
                    'DestBairro' => 'Centro',
                    'DestMunicipio' => 'Rio de Janeiro',
                    'DestEstado' => 'RJ',
                    'DestCep' => '87656908',
                    'DestTipoLocalEntrega' => 'tleeDesconhecido',
                    'DestPais' => 'Brasil'
                  }
                }
              }
      }

      it 'should be a hash with the proper keys and values for export' do
        subject.parsed_data.should == expected_parsed_data
      end
    end
    end
end
