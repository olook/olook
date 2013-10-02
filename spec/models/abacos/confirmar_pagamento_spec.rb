# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmarPagamento do
  context 'when instantiated with a non-authorized payment' do
    let(:order) do
      result = FactoryGirl.create :clean_order
      result.stub(:'authorized?').and_return(false)
      result
    end
    
    it 'should raise and error' do
      expect {
        described_class.new order
      }.to raise_error "Order number #{order.number} isn't authorized"
    end
  end
  
  context 'when instantiated with an authorized payment' do
    let(:order) do
      result = FactoryGirl.create :clean_order
      result.stub(:'authorized?').and_return(true)
      result.stub(:paid_at).and_return(Time.zone.now)
      result.erp_payment.update_attributes!({
        gateway_response_status: "Sucesso",
        gateway_transaction_code: "046455",
        gateway_transaction_status: "EmAnalise",
        gateway_message: "Transação autorizada",
        gateway_return_code: 46455
      })
      result
    end

    subject { described_class.new order }
    
    it '#numero_pedido' do
      subject.numero_pedido.should == order.number
    end
    it '#data' do
      subject.data.should == subject.parse_datetime(order.erp_payment.created_at)
    end
    it '#status' do
      subject.status.should == 'speConfirmado'
    end
    it '#codigo_autorizacao' do
      subject.codigo_autorizacao.should == '046455'
    end
    it '#mensagem_retorno' do
      subject.mensagem_retorno.should == 'Transação autorizada'
    end
    it '#codigo_retorno' do
      subject.codigo_retorno.should == 46455
    end
    
    describe '#parsed_data' do
      let(:expected_data) do
        {
          'NumeroPedido'            => order.number,
          'DataPagamento'           => subject.parse_datetime(order.erp_payment.created_at),
          'StatusPagamento'         => 'speConfirmado',
          'CartaoCodigoAutorizacao' => '046455',
          'CartaoMensagemRetorno'   => 'Transação autorizada',
          'CartaoCodigoRetorno'     => 46455
        }
      end

      it 'should return a hash properly formed' do
        subject.parsed_data.should == expected_data
      end
    end
  end
end
