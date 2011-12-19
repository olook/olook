# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Pagamento do
  describe 'basic attributes' do
    let(:payment) { mock_model CreditCard, :payments => 3, :bank => 'visa' }
    let(:order) { double :order, :payment => payment, :total_with_freight => 179.9 }
    subject { described_class.new order }

    it '#valor' do
      subject.valor.should == '179.90'
    end

    it '#parcelas' do
      subject.parcelas.should == 3
    end

    describe '#parsed_data' do
      let(:expected_data) do
        {
          'DadosPedidosFormaPgto' => {
            'Valor'                 => '179.90',
            'CartaoQtdeParcelas'    => 3,
            'FormaPagamentoCodigo'  => 'VISA'
          }
        }
      end

      it 'should return a hash properly formed' do
        subject.parsed_data.should == expected_data
      end
    end
  end

  describe '#forma' do
    context 'for boletos' do
      let(:billet) { mock_model Billet, :payments => 1 }
      let(:order) { double :order, :total_with_freight => 179.9, :payment => billet }
      subject { described_class.new order }
      it '#forma should be BOLETO' do
        subject.forma.should == 'BOLETO'
      end
    end

    context 'for débito' do
      let(:billet) { mock_model Debit, :bank => 'itau', :payments => 1 }
      let(:order) { double :order, :total_with_freight => 179.9, :payment => billet }
      subject { described_class.new order }
      it '#forma should be a bank name, like ITAU, BRADESCO' do
        subject.forma.should == 'ITAU'
      end
    end

    context 'for cartão de crédito' do
      let(:billet) { mock_model CreditCard, :bank => 'visa', :payments => 1 }
      let(:order) { double :order, :total_with_freight => 179.9, :payment => billet }
      subject { described_class.new order }
      it '#forma should be the card operator, like VISA, MASTERCARD' do
        subject.forma.should == 'VISA'
      end
    end
  end
end
