# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::OrderAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSPedidos+./).should be_true
  end

  let(:order) { FactoryGirl.create :clean_order }

  describe '#insert_order' do
    let(:fake_data) { {:fake_data => :order} }
    let(:fake_order) { double :order, :parsed_data => fake_data, :numero => order.number }
    let(:fake_data_with_key) do
      result = fake_data
      result["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      result
    end
    it 'should call the inserir_pedido web service and return true if it succeeds' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :inserir_pedido, fake_data_with_key).and_return({:resultado_operacao => {:tipo => 'tdreSucesso'}})
      described_class.insert_order(fake_order).should be_true
    end

    it 'should raise an error if the call fails' do
      described_class.stub(:call_webservice).and_return({:resultado_operacao => {:tipo => 'tdreErro'}})
      expect {
        described_class.insert_order(nil)
      }.to raise_error
    end
  end

  describe '#order_exists?' do
    let(:fake_data) { {:fake_data => :order_number} }
    let(:fake_data_with_key) do
      result = {'ListaDeNumerosDePedidos' => {'string' => 123}}
      result["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      result
    end
    it 'should return true if the pedido exists' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :pedido_existe, fake_data_with_key).and_return({:rows => {:dados_pedidos_existentes => {:existente => true}}})
      described_class.order_exists?(123).should be_true
    end
    it "should return false if the pedido doesn't exist" do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :pedido_existe, fake_data_with_key).and_return({:rows => {:dados_pedidos_existentes => {:existente => false}}})
      described_class.order_exists?(123).should be_false
    end
  end

  describe '#confirm_payment' do
    let(:fake_payment) { double :payment, :parsed_data => {:parsed_fake_payment => 123}, :numero_pedido => order.number }
    let(:fake_data_with_key) do
      result = {'ListaDePagamentos' => {'DadosPgtoPedido' => {:parsed_fake_payment => 123}}}
      result["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      result
    end
    it 'should return true if payment was processed' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_pagamentos_pedidos, fake_data_with_key).and_return(:resultado_operacao => {:tipo => 'tdreSucesso'})
      described_class.confirm_payment(fake_payment).should be_true
    end
    it "should return raise an error if the process fails" do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_pagamentos_pedidos, fake_data_with_key).and_return(:resultado_operacao => {:tipo => 'tdreErro'})
      expect {
        described_class.confirm_payment(fake_payment)
      }.to raise_error
    end
  end

  describe '#cancel_order' do
    let(:fake_cancelation) { double :cancelation, :parsed_data => {:parsed_fake_cancelation => 123}, :numero_pedido => order.number }
    let(:fake_data_with_key) do
      result = {'ListaDePagamentos' => {'DadosPgtoPedido' => {:parsed_fake_cancelation => 123}}}
      result["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      result
    end
    it 'should return true if cancelation was processed' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_pagamentos_pedidos, fake_data_with_key).and_return(:resultado_operacao => {:tipo => 'tdreSucesso'})
      described_class.cancel_order(fake_cancelation).should be_true
    end
    it "should return raise an error if the process fails" do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_pagamentos_pedidos, fake_data_with_key).and_return(:resultado_operacao => {:tipo => 'tdreErro'})
      expect {
        described_class.cancel_order(fake_cancelation)
      }.to raise_error
    end
  end

  describe '#download_orders_statuses', vcr: {cassette_name: 'StatusPedidoDisponiveis', :record => :once} do

    it "should return products that are available to integration" do
      orders = described_class.send :download_orders_statuses
      orders.should be_kind_of(Array)
      orders.length.should == 1
    end
  end

  describe '#confirm_order_status' do
    let(:fake_protocol) { 'PROT-ORD-123' }

    it 'calls the ConfirmarRecebimentoStatusPedido API' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_recebimento_status_pedido, {"ProtocoloStatusPedido" => fake_protocol}).and_return({:tipo => 'tdreSucesso'})
      described_class.confirm_order_status fake_protocol
    end

    context "when response type is 'tdreSucesso'" do
      it "returns true" do
        described_class.stub(:call_webservice).with(described_class.wsdl, :confirmar_recebimento_status_pedido, {"ProtocoloStatusPedido" => fake_protocol}).and_return({:tipo => 'tdreSucesso'})
        described_class.confirm_order_status(fake_protocol).should be_true
      end
    end

    context "when response type is not 'tdreSucesso'" do
      it 'raises a webservice error' do
        described_class.stub(:call_webservice).with(described_class.wsdl, :confirmar_recebimento_status_pedido, {"ProtocoloStatusPedido" => fake_protocol}).and_return({:tipo => 'FAIL'})
        expect { described_class.confirm_order_status fake_protocol }.to raise_error
      end
    end
  end
end
