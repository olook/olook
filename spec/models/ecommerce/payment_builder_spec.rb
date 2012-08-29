require "spec_helper"

describe PaymentBuilder do

  let(:user) { FactoryGirl.create(:user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:credit_card) { FactoryGirl.create(:credit_card, :order => order) }
  let(:billet) { FactoryGirl.create(:billet, :order => order) }
  let(:debit) { FactoryGirl.create(:debit, :order => order) }
  
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:cart_service) { CartService.new({
    :cart => cart,
    :freight => freight,
  }) }
  
  subject { 
    pb = PaymentBuilder.new(cart_service, credit_card) 
    pb.credit_card_number = credit_card.credit_card_number
    pb 
  }
  let(:payer) { subject.payer }

  let(:order_total) { 12.34 }

  before :each do
    Airbrake.stub(:notify)
    # order.stub(:total).and_return(10.50)
    # @order_total = order.amount_paid
  end

  it "should verify if MoIP uri was properly initialized" do
    moip_uri = MoIP.uri
    moip_uri.should be_true
  end

  it "should verify if MoIP token was properly initialized" do
    moip_token = MoIP.token
    moip_token.should be_true
  end

  it "should verify if MoIP key was properly initialized" do
    moip_key = MoIP.key
    moip_key.should be_true
  end

  context "on success" do
    it "should process the payment" do
      subject.should_receive(:send_payment!)
      subject.should_receive(:create_payment_response!)
      payment = double
      payment.stub_chain(:payment_response, :response_status)
      subject.should_receive(:set_payment_url!).and_return(payment)
      subject.process!
    end

    context "success actions" do
      before :each do
        subject.stub(:send_payment!)
        subject.stub(:create_payment_response!)
        payment_response = double
        payment_response.stub(:response_status).and_return(Payment::SUCCESSFUL_STATUS)
        payment_response.stub(:transaction_status).and_return(:success)
        subject.stub_chain(:set_payment_url!, :payment_response).and_return(payment_response)
        credit_card.stub(:payment_response).and_return(payment_response)
      end
      
      xit "should set payment order" do
        subject.set_payment_order!
        subject.payment.order.should == order
      end
      
      xit "should decrement the inventory for each item" do
        basic_shoe_35_inventory = basic_shoe_35.inventory
        basic_shoe_40_inventory = basic_shoe_40.inventory
        subject.line_items.create( 
          :variant_id => basic_shoe_35.id,
          :quantity => quantity, 
          :price => basic_shoe_35.price,
          :retail_price => basic_shoe_35.retail_price)
        subject.line_items.create( 
          :variant_id => basic_shoe_40.id,
          :quantity => quantity, 
          :price => basic_shoe_40.price,
          :retail_price => basic_shoe_40.retail_price)
        subject.decrement_inventory_for_each_item
        basic_shoe_35.reload.inventory.should == basic_shoe_35_inventory - quantity
        basic_shoe_40.reload.inventory.should == basic_shoe_40_inventory - quantity
      end

      xit "should create a coupon when used" do
        expect {
          cart_service = CartService.new({:cart => cart, :freight => freight, :coupon => coupon_of_value})
          cart_service.stub(:total_coupon_discount => 100)
          order = cart_service.generate_order!
          order.used_coupon.coupon.should be(coupon_of_value)
        }.to change{Order.count}.by(1)
      end


      it "should return a structure with status and a payment" do
        response = subject.process!
        response.status.should == Payment::SUCCESSFUL_STATUS
        response.payment.should == credit_card
      end

      xit "should invalidate the order coupon" do
        Coupon.any_instance.should_receive(:decrement!)
        subject.process!
      end
    end
  end

  context "on failure" do
    before :each do
      subject.stub(:send_payment!)
      subject.stub(:create_payment_response!)
      @payment_response = double
    end

    it "should return a structure with failure status and without a payment when the gateway comunication fail " do
      @payment_response.stub(:response_status).and_return(Payment::FAILURE_STATUS)
      subject.stub_chain(:set_payment_url!, :payment_response).and_return(@payment_response)
      credit_card.stub(:payment_response).and_return(@payment_response)
      subject.process!.status.should == Payment::FAILURE_STATUS
      subject.process!.payment.should be_nil
    end

    it "should return a structure with failure status and without a payment" do
      @payment_response.stub(:response_status).and_return(Payment::SUCCESSFUL_STATUS)
      @payment_response.stub(:transaction_status).and_return(Payment::CANCELED_STATUS)
      subject.stub_chain(:set_payment_url!, :payment_response).and_return(@payment_response)
      credit_card.stub(:payment_response).and_return(@payment_response)
      subject.process!.status.should == Payment::FAILURE_STATUS
      subject.process!.payment.should be_nil
    end

    it "should return a structure with failure status and without a payment" do
      subject.stub(:send_payment!).and_raise(Exception)
      subject.process!.status.should == Payment::FAILURE_STATUS
      subject.process!.payment.should be_nil
    end
  end

  it "should creates a payment response" do
    subject.payment.stub(:build_payment_response).and_return(payment_response = mock)
    payment_response.should_receive(:build_attributes).with(subject.response)
    payment_response.should_receive(:save!)
    subject.create_payment_response!
  end

  it "should set payment url" do
    subject.stub(:payment_url).and_return('www.fake.com')
    subject.set_payment_url!
    subject.payment.url.should == 'www.fake.com'
  end

  it "should send payments" do
    MoIP::Client.should_receive(:checkout).with(subject.payment_data)
    subject.send_payment!
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
    expected_expiration_date = billet.payment_expiration_date.strftime("%Y-%m-%dT15:00:00.0-03:00")
    expected = { :valor => order_total, :id_proprio => billet.identification_code,
                :forma => subject.payment.to_s, :recebimento => billet.receipt, :pagador => payer,
                :razao=> Payment::REASON, :data_vencimento => expected_expiration_date }

    subject.payment_data.should == expected
  end

  it "should return payment data for debit" do
    subject.payment = debit
    expected = { :valor => order_total, :id_proprio => debit.identification_code, :forma => subject.payment.to_s,
               :instituicao => debit.bank, :recebimento => debit.receipt, :pagador => payer,
               :razao => Payment::REASON }

    subject.payment_data.should == expected
  end

  it "should return payment data for credit card" do
    subject.payment = credit_card
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
