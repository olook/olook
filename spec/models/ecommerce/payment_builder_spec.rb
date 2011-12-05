require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.build(:credit_card, :order => order) }
  let(:billet) { FactoryGirl.build(:billet, :order => order) }
  let(:debit) { FactoryGirl.build(:debit, :order => order) }
  subject { PaymentBuilder.new(order, credit_card) }
  let(:payer) { subject.payer }

  before :each do
    order.stub(:total).and_return(10.50)
    @order_total = order.total_with_freight
  end

  it "should process the payment" do
    subject.should_receive(:send_payment)
    subject.should_receive(:create_successful_payment_response)
    payment = double
    payment.stub_chain(:payment_response, :response_status)
    subject.should_receive(:save_payment).and_return(payment)
    subject.process!
  end

  it "should return a structure with status and a payment" do
    subject.stub(:send_payment)
    subject.stub(:create_successful_payment_response)
    payment_response = double
    payment_response.stub(:response_status).and_return(status = "Sucesso")
    subject.stub_chain(:save_payment, :payment_response).and_return(payment_response)
    subject.process!.status.should == status
    subject.process!.payment.should == credit_card
  end

  it "should return a structure with failure status and without a payment" do
    subject.stub(:send_payment).and_raise(Exception)
    subject.process!.status.should == Payment::FAILURE_STATUS
    subject.process!.payment.should be_nil
  end

  it "should creates a payment response" do
    subject.payment.stub(:build_payment_response).and_return(payment_response = mock)
    payment_response.should_receive(:build_attributes).with(subject.response)
    payment_response.should_receive(:save)
    subject.create_successful_payment_response
  end

  it "should set_url_and_order_to_payment" do
    subject.stub(:payment_url).and_return('www.fake.com')
    subject.set_url_and_order_to_payment
    subject.payment.url.should == 'www.fake.com'
    subject.payment.order.should == order
  end

  it "should save payments" do
    subject.stub(:set_url_and_order_to_payment)
    subject.save_payment
    subject.payment.should be_persisted
  end

  it "should send payments" do
    MoIP::Client.should_receive(:checkout).with(subject.payment_data)
    subject.send_payment
  end

  it "should get the payment_url" do
    subject.response = {"Token" => "XCV"}
    MoIP::Client.should_receive(:moip_page).with(subject.response["Token"])
    subject.payment_url
  end

  it "should return the payer" do
    delivery_address = order.freight.address
    expected = {
      :nome => order.user_name,
      :email => order.user_email,
      :identidade => credit_card.user_identification,
      :logradouro => delivery_address.street,
      :complemento => delivery_address.complement,
      :numero => delivery_address.number,
      :bairro => delivery_address.neighborhood,
      :cidade => delivery_address.city,
      :estado => delivery_address.state,
      :pais => delivery_address.country,
      :cep => delivery_address.zip_code,
      :tel_fixo => delivery_address.telephone
    }

    subject.payer.should == expected
  end

  it "should return payment data for billet" do
    subject.payment = billet
    expected = { :valor => @order_total, :id_proprio => order.identification_code,
                :forma => subject.payment.to_s, :recebimento => billet.receipt, :pagador => payer,
                :razao=> Payment::REASON  }

    subject.payment_data.should == expected
  end

  it "should return payment data for debit" do
    subject.payment = debit
    expected = { :valor => @order_total, :id_proprio => order.identification_code, :forma => subject.payment.to_s,
               :instituicao => debit.bank, :recebimento => debit.receipt, :pagador => payer,
               :razao => Payment::REASON }

    subject.payment_data.should == expected
  end

  it "should return payment data for credit card" do
    subject.payment = credit_card
    payer = subject.payer
    expected = { :valor => @order_total, :id_proprio => order.identification_code, :forma => subject.payment.to_s,
              :instituicao => credit_card.bank, :numero => credit_card.credit_card_number,
              :expiracao => credit_card.expiration_date, :codigo_seguranca => credit_card.security_code,
              :nome => credit_card.user_name, :identidade => credit_card.user_identification,
              :telefone => credit_card.telephone, :data_nascimento => credit_card.user_birthday,
              :parcelas => credit_card.payments, :recebimento => credit_card.receipt,
              :pagador => payer, :razao => Payment::REASON }

    subject.payment_data.should == expected
  end
 end
