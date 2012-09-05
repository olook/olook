# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::CancelarPedido do

  context 'when instantiated with a non-canceled payment' do
    let(:order) do
      result = FactoryGirl.create :clean_order
      result.stub(:'canceled?').and_return(false)
      result
    end
    
    it 'should raise and error' do
      expect {
        described_class.new order
      }.to raise_error "Order number #{order.number} isn't canceled"
    end
  end
  
  context 'when instantiated with a canceled payment' do
    let(:order) do
      result = FactoryGirl.create :clean_order
      result.stub(:'canceled?').and_return(true)
      result.erp_payment.update_attributes!({
        gateway_response_status: "Sucesso",
        gateway_transaction_code: nil,
        gateway_transaction_status: "Cancelado",
        gateway_message: "Autorização negada",
        gateway_return_code: nil
      })
      result
    end

    subject { 
      described_class.new order 
    }
    
    it '#numero_pedido' do
      subject.numero_pedido.should == order.number
    end
    it '#data' do
      subject.data.should == subject.parse_datetime(order.erp_payment.created_at)
    end
    it '#status' do
      subject.status.should == 'speRecusado'
    end
    it '#codigo_autorizacao' do
      subject.codigo_autorizacao.should == nil
    end
    it '#mensagem_retorno' do
      subject.mensagem_retorno.should == 'Autorização negada'
    end
    it '#codigo_retorno' do
      subject.codigo_retorno.should == nil
    end
    
    describe '#parsed_data' do
      let(:expected_data) do
        {
          'NumeroPedido'            => order.number,
          'DataPagamento'           => subject.parse_datetime(order.erp_payment.created_at),
          'StatusPagamento'         => 'speRecusado',
          'CartaoCodigoAutorizacao' => nil,
          'CartaoMensagemRetorno'   => 'Autorização negada',
          'CartaoCodigoRetorno'     => nil
        }
      end

      it 'should return a hash properly formed' do
        subject.parsed_data.should == expected_data
      end
    end
  end
end
