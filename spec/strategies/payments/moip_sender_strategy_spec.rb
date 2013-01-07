require "spec_helper"

describe Payments::MoipSenderStrategy do

  let(:user) { FactoryGirl.create(:user) }
  let(:payment) {FactoryGirl.create(:payment)}
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order) }
  let(:credit_card_with_response) { FactoryGirl.create(:credit_card_with_response) }
  let(:billet) { FactoryGirl.create(:billet, :order => order) }
  let(:debit) { FactoryGirl.create(:debit, :order => order) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_service) { CartService.new({
    :cart => cart,
    :freight => freight
  }) }
  let(:order_total) { 12.34 }


  it "should be initialize with success" do
    Payments::MoipSenderStrategy.new(cart_service, payment).should be_true
  end

  context "with a valid class" do

    subject {Payments::MoipSenderStrategy.new(cart_service, payment)}

    it "should set url on payment" do
      subject.stub(:payment_url).and_return('www.fake.com')
      subject.save_payment_url!
      payment.url.should == 'www.fake.com'
    end

    it "should send payments" do
      MoIP::Client.should_receive(:checkout).with(subject.payment_data)
      payment.stub(:build_response)
      payment.stub(:gateway_response_status).and_return(Payment::SUCCESSFUL_STATUS)
      payment.stub(:gateway_transaction_status).and_return(:success)
      subject.stub(:payment_url).and_return('www.fake.com')
      subject.send_to_gateway
    end

    it "should set payment gateway" do
      subject.set_payment_gateway
      subject.payment.gateway.should eq(1)
    end

    it "should get the payment_url" do
      subject.response = {"Token" => "XCV"}
      MoIP::Client.should_receive(:moip_page).with(subject.response["Token"])
      subject.payment_url
    end

    it "should return the payer" do
      delivery_address = order.freight.address
      expected = {
        :nome => user.name,
        :email => user.email,
        :identidade => payment.user_identification,
        :logradouro => delivery_address.street,
        :complemento => delivery_address.complement,
        :numero => delivery_address.number,
        :bairro => delivery_address.neighborhood,
        :cidade => delivery_address.city,
        :estado => delivery_address.state,
        :pais => delivery_address.country,
        :cep => delivery_address.zip_code,
        :tel_fixo => delivery_address.telephone,
        :tel_cel => delivery_address.mobile
      }

      subject.payer.should == expected
    end


    it "should return payment data for billet" do
      subject.payment = billet
      expected_expiration_date = billet.payment_expiration_date.strftime("%Y-%m-%dT15:00:00.0-03:00")
      expected = { :valor => order_total, :id_proprio => billet.identification_code,
                  :forma => billet.to_s, :recebimento => billet.receipt, :pagador => subject.payer,
                  :razao=> Payment::REASON, :data_vencimento => expected_expiration_date }

      subject.payment_data.should == expected
    end

    it "should return payment data for debit" do
      subject.payment = debit
      expected = { :valor => order_total, :id_proprio => debit.identification_code, :forma => subject.payment.to_s,
                 :instituicao => debit.bank, :recebimento => debit.receipt, :pagador => subject.payer,
                 :razao => Payment::REASON }

      subject.payment_data.should == expected
    end

    it "should return payment data for credit card" do
      subject.payment = credit_card
      subject.credit_card_number = credit_card.credit_card_number
      payer = subject.payer
      expected = { :valor => order_total, :id_proprio => credit_card.identification_code, :forma => subject.payment.to_s,
                :instituicao => credit_card.bank, :numero => credit_card.credit_card_number,
                :expiracao => credit_card.expiration_date, :codigo_seguranca => credit_card.security_code,
                :nome => credit_card.user_name, :identidade => credit_card.user_identification,
                :telefone => credit_card.telephone, :data_nascimento => credit_card.user_birthday,
                :parcelas => credit_card.payments, :recebimento => credit_card.receipt,
                :pagador => payer, :razao => Payment::REASON }

      subject.payment_data.should == expected
    end

  end

  context "#payment_successful" do
    subject {Payments::MoipSenderStrategy.new(cart_service, payment)}

    it "should return false when response status is not successful" do
      credit_card.gateway_response_status = Payment::CANCELED_STATUS
      subject.payment = credit_card
      subject.payment_successful?.should eq(false)
    end

    it "should return false when transaction status is canceled" do
      credit_card.gateway_response_status = Payment::SUCCESSFUL_STATUS
      credit_card.gateway_transaction_status = Payment::CANCELED_STATUS
      subject.payment = credit_card
      subject.payment_successful?.should eq(false)
    end

    it "should return false when transaction status is canceled" do
      credit_card.gateway_response_status = Payment::SUCCESSFUL_STATUS
      credit_card.gateway_transaction_status = Payment::SUCCESSFUL_STATUS
      subject.payment = credit_card
      subject.payment_successful?.should eq(true)
    end
  end

  context "formatting the telephone number" do
    subject {Payments::MoipSenderStrategy.new(cart_service, payment)}

    it "should remove the ninth digit of the telephone" do
      subject.format_telephone("(11)99123-4567").should eq("(11)9123-4567")
    end

    it "should correct a wrong mask" do
      subject.format_telephone("(11)91234-567").should eq("(11)9123-4567")
    end

  end

end
