# -*- encoding : utf-8 -*
require "spec_helper"

describe Abacos::PedidoPresente do
  let(:member)  { FactoryGirl.create :member,
                    :cpf => '98765432198',
                    :email => 'janedoe@test.com', :first_name => 'Jéssica', :last_name => 'Maíra'
                }
  let(:payment) { FactoryGirl.create :credit_card }
  let(:freight) { FactoryGirl.create :freight, :price => 22.0, :cost => 18.0, :delivery_time => 5 }
  let(:order) { FactoryGirl.create :clean_order, :user => member, :credits => 11.0, :payment => payment, :freight => freight, :created_at => Date.civil(2011, 12, 01) }
  let(:gift_order) { FactoryGirl.create :clean_order, :user => member, :credits => 11.0, :payment => payment, :freight => freight, :created_at => Date.civil(2011, 12, 01), :restricted => true, :gift_wrap => true, :gift_message => 'Mensagem para presente'  }
  let(:variant_a) { FactoryGirl.create :basic_shoe_size_35 }
  let(:variant_b) { FactoryGirl.create :basic_shoe_size_40 }
  let!(:line_item_1) { FactoryGirl.create :line_item, :order => order, :variant => variant_a, :quantity => 2, :price => 20.0 }
  let!(:line_item_2) { FactoryGirl.create :line_item, :order => order, :variant => variant_b, :quantity => 1, :price => 30.0 }
  let!(:line_item_3) { FactoryGirl.create :line_item, :order => gift_order, :gift_wrap => true , :variant => variant_a, :quantity => 2, :price => 20.0 }
  let!(:line_item_4) { FactoryGirl.create :line_item, :order => gift_order, :gift_wrap => true , :variant => variant_b, :quantity => 1, :price => 30.0 }


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
end
