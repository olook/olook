# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Pagamento do
  
  let(:expiration_date) { DateTime.civil(2012, 11, 9, 10, 0, 0) }
  let(:order)  { FactoryGirl.create :clean_order, :amount_paid => 179.90 }
  let(:payment_credit_card) { FactoryGirl.create :credit_card, :order => order, :payments => 3, :bank => 'visa' }
  let(:payment_billet) do
    result = FactoryGirl.create :billet, :order => order, :payments => 1 
    result.update_attribute(:payment_expiration_date, expiration_date)
    result
  end
  let(:payment_debit) { FactoryGirl.create :debit, :order => order, :payments => 1, :bank => 'itau' }

  
  describe 'basic attributes' do
    subject { described_class.new payment_credit_card.order }

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
            'FormaPagamentoCodigo'  => 'VISA',
            'BoletoVencimento'  => nil
          }
        }
      end

      it 'should return a hash properly formed' do
        subject.parsed_data.should == expected_data
      end
    end
  end

  describe 'diferent payments' do
    context 'for boletos' do
      subject { described_class.new payment_billet.order }
  
      let(:billet_parsed_data) do
        {
         'DadosPedidosFormaPgto' => {
           'Valor'                 => '179.90',
           'CartaoQtdeParcelas'    => 1,
           'FormaPagamentoCodigo'  => 'BOLETO',
           'BoletoVencimento'  => "09112012"
        }
       }
      end

      it '#forma should be BOLETO' do
        subject.parsed_data.should == billet_parsed_data
      end
    end

    context 'for débito' do
      subject { described_class.new payment_debit.order }
      
      it '#forma should be a bank name, like ITAU, BRADESCO' do
        subject.forma.should == 'ITAU'
      end
    end

    context 'for cartão de crédito' do
      subject { described_class.new payment_credit_card.order }

      it '#forma should be the card operator, like VISA, MASTERCARD' do
        subject.forma.should == 'VISA'
      end
    end
  end
end
