require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:delivery_address) { FactoryGirl.create(:address, :user => user)}
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { FactoryGirl.create(:payment, :order => order) }
  subject { PaymentBuilder.new(order, payment, delivery_address) }
  let(:payer) { subject.payer }

  before :each do
    order.stub(:total).and_return(10.50)
  end

  it "should return the payer" do
    expected = {
      :nome => order.user_name,
      :email => order.user_email,
      :logradouro => delivery_address.street,
      :complemento => delivery_address.complement,
      :numero => delivery_address.number,
      :bairro => delivery_address.neighborhood,
      :cidade => delivery_address.city,
      :estado => delivery_address.state,
      :pais => delivery_address.country,
      :cep => delivery_address.zip_code,
      :tel_fixo => delivery_address.telephone }

    subject.payer.should == expected
  end

  it "should return payment data for billet" do
    expected = { :valor => order.total, :id_proprio => order.id,
                :forma => payment.to_s, :pagador => payer,
                :razao=> Payment::REASON  }

    subject.payment_data.should == expected
  end

  it "should return payment data for debit" do
    subject.payment.payment_type = Payment::TYPE[:debit]
    expected = { :valor => order.total, :id_proprio => order.id, :forma => payment.to_s,
               :instituicao => payment.bank, :pagador => payer,
               :razao => Payment::REASON }

    subject.payment_data.should == expected
  end

  it "should return payment data for credit card" do
    subject.payment.payment_type = Payment::TYPE[:credit]
    payer = subject.payer
    expected = { :valor => order.total, :id_proprio => order.id, :forma => payment.to_s,
              :instituicao => payment.bank, :numero => payment.credit_card_number,
              :expiracao => payment.expiration_date, :codigo_seguranca => payment.security_code,
              :nome => payment.user_name, :identidade => payment.user_identification,
              :telefone => payment.telephone, :data_nascimento => payment.user_birthday,
              :parcelas => payment.payments, :recebimento => payment.receipt,
              :pagador => payer, :razao => Payment::REASON }

    subject.payment_data.should == expected
  end
 end
