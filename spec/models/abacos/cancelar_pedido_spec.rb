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
      result
    end
    
    let(:payment) do
      result = FactoryGirl.create :credit_card, :order => order
      result.payment_response = FactoryGirl.create :canceled_payment, :payment => result
      result.payment_response.update_attribute('created_at', DateTime.civil(2012, 04, 12, 13, 44, 55))
      result
    end

    subject { 
      described_class.new payment.order 
    }
    
    it '#numero_pedido' do
      subject.numero_pedido.should == order.number
    end
    it '#data' do
      subject.data.should == '12042012 10:44:55'
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
          'DataPagamento'           => '12042012 10:44:55',
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
