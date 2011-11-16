require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:delivery_address) { FactoryGirl.create(:address, :user => user)}
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { FactoryGirl.build(:payment, :order => order) }
  subject { PaymentBuilder.new(order, payment, delivery_address) }
  let(:payer) { subject.payer }

  before :each do
    order.stub(:total).and_return(10.50)
  end

  it "should process the payment" do
    subject.should_receive(:send_payment)
    subject.should_receive(:create_payment_response)
    subject.should_receive(:save_payment)
    subject.process!
  end

  it "should creates a payment response" do
    subject.payment.stub(:build_payment_response).and_return(payment_response = mock)
    payment_response.should_receive(:build_attributes).with(subject.response)
    payment_response.should_receive(:save)
    subject.create_payment_response
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
