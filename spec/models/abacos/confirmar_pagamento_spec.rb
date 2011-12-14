# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmarPagamento do
  let(:response) { FactoryGirl.create :authorized_payment }

  context 'when instantiated with a non-authorized payment' do
    let(:payment) { FactoryGirl.create :credit_card, :payment_response => response }
    let(:order) { FactoryGirl.create :clean_order, :payment => payment }
    
    it 'should raise and error' do
      expect {
        described_class.new order
      }.to raise_error "Payment for order #{order.number} isn't authorized"
    end
  end
  
  context 'when instantiated with an authorized payment' do
    let(:payment) do
      result = FactoryGirl.create :credit_card, :payment_response => response
      result.stub(:'authorized?').and_return(true)
      result
    end
    let(:order) { FactoryGirl.create :clean_order, :payment => payment }
    
    before :each do
      order.payment.payment_response.stub(:created_at).and_return(DateTime.civil(2012, 04, 12, 10, 44, 55))
    end

    subject { described_class.new order }
    
    attr_reader :numero_pedido, :data, :status, :codigo_autorizacao,
                  :mensagem_retorno, :codigo_retorno

    it '#numero_pedido' do
      subject.numero_pedido.should == order.number
    end
    it '#data' do
      subject.data.should == '12042012 10:44:55'
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
          'DataPagamento'           => '12042012 10:44:55',
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
