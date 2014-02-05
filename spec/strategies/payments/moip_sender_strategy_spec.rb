require "spec_helper"

describe Payments::MoipSenderStrategy do

  let(:user) { FactoryGirl.build(:user) }
  let(:payment) {FactoryGirl.build(:payment)}
  let(:shipping_service) { FactoryGirl.build :shipping_service }
  let(:order) { FactoryGirl.build(:order, :user => user) }
  let(:credit_card) { FactoryGirl.build(:credit_card, :order => order) }
  let(:credit_card_with_response) { FactoryGirl.build(:credit_card_with_response) }
  let(:billet) { FactoryGirl.create(:billet, :order => order) }
  let(:debit) { FactoryGirl.build(:debit, :order => order) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:freight) { {price: 12.34, cost: 2.34, delivery_time: 2, shipping_service_id: shipping_service.id, address: {id: address.id}} }
  let(:cart) { FactoryGirl.build(:cart_with_items, :user => user) }
  let(:cart_service) { CartService.new({
    :cart => cart
  }) }
  let(:order_total) { 12.34 }

  subject { Payments::MoipSenderStrategy.new(cart_service, payment) }

  describe "#initialize" do
    context "with no arguments" do
      it "raises an ArgumentError" do
        expect { Payments::MoipSenderStrategy.new() }.to raise_error(ArgumentError)
      end
    end
  end

  describe  "#save_payment_url!" do
    it "sets url on payment" do
      subject.stub(:payment_url).and_return('www.fake.com')
      subject.save_payment_url!
      expect(payment.url).to eql('www.fake.com')
    end
  end

  describe "#send_to_gateway" do
    before(:each) do
      MoIP::Client.stub :checkout
      payment.stub(:build_response)
      payment.stub(:gateway_response_status).and_return(Payment::SUCCESSFUL_STATUS)
      payment.stub(:gateway_transaction_status).and_return(:success)
      subject.stub(:payment_url).and_return('www.fake.com')
    end

    #weird
    it "gets freight from CartService" do
      CartService.any_instance.should_receive(:freight).and_return(freight)
      subject.send_to_gateway
    end

    it "passes payment data to Moip::Client" do
      CartService.any_instance.stub(:freight).and_return(freight)
      MoIP::Client.should_receive(:checkout).with(subject.payment_data)
      subject.send_to_gateway
    end

    context "when exception is thrown" do
      before(:each) do
        CartService.any_instance.stub(:freight).and_return(freight)
        MoIP::Client.stub(:checkout).and_raise(Exception)
      end

      it "ensures the payment is saved" do
        payment.should_receive(:save!).and_return true
        subject.send_to_gateway
      end

      it "returns an OpenStruct with failure status" do
        response = subject.send_to_gateway
        expect(response.class).to eql(OpenStruct)
        expect(response.status).to eql(Payment::FAILURE_STATUS)
      end

      it "notifies the error with the payment info" do
        ErrorNotifier.should_receive(:send_notifier).with("Moip", kind_of(Exception), payment)
        subject.send_to_gateway
      end
    end
  end

  describe "#set_payment_gateway" do
    it "sets payment.gateway" do
      subject.set_payment_gateway
      expect(subject.payment.gateway).to eq(1)
    end
  end

  describe "#payment_url" do
    it "passes the response token to the MoIP::Client" do
      subject.response = {"Token" => "XCV"}
      MoIP::Client.should_receive(:moip_page).with(subject.response["Token"])
      subject.payment_url
    end
  end

  describe "#payer" do
    it "returns a hash with the customer's data" do
      CartService.any_instance.should_receive(:freight).and_return(freight)
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
  end

  describe "#payment_data" do  
    before(:each) { CartService.any_instance.should_receive(:freight).twice.and_return(freight) }
    
    context "for billet" do
      it "returns a hash with its payment data" do
        subject.payment = billet
        expected_expiration_date = billet.payment_expiration_date.strftime("%Y-%m-%dT15:00:00.0-03:00")
        expected = { :valor => order_total, :id_proprio => billet.identification_code,
                    :forma => billet.to_s, :recebimento => billet.receipt, :pagador => subject.payer,
                    :razao=> Payment::REASON, :data_vencimento => expected_expiration_date }

        subject.payment_data.should == expected
      end
    end

    context "for debit" do
      it "returns a hash with its payment data" do
        subject.payment = debit
        expected = { :valor => order_total, :id_proprio => debit.identification_code, :forma => subject.payment.to_s,
                   :instituicao => debit.bank, :recebimento => debit.receipt, :pagador => subject.payer,
                   :razao => Payment::REASON }

        subject.payment_data.should == expected
      end
    end

    context "for credit card" do
      it "returns a hash with its payment data" do
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
  end

  describe "#payment_successful" do
    context "response is cancelled" do
      it "returns false" do
        credit_card.gateway_response_status = Payment::CANCELED_STATUS
        subject.payment = credit_card
        subject.payment_successful?.should eq(false)
      end
    end

    context "response is successful but transaction is cancelled" do
      it "returns false" do
        credit_card.gateway_response_status = Payment::SUCCESSFUL_STATUS
        credit_card.gateway_transaction_status = Payment::CANCELED_STATUS
        subject.payment = credit_card
        subject.payment_successful?.should eq(false)
      end
    end

    context "response is successful and transaction is successful" do
      it "returns true" do
        credit_card.gateway_response_status = Payment::SUCCESSFUL_STATUS
        credit_card.gateway_transaction_status = Payment::SUCCESSFUL_STATUS
        subject.payment = credit_card
        subject.payment_successful?.should eq(true)
      end
    end
  end

  describe "#format_telephone" do
    it "removes the ninth digit of the telephone" do
      subject.format_telephone("(21)99123-4567").should eq("(21)9123-4567")
    end

    it "corrects a wrong mask" do
      subject.format_telephone("(11)91234-567").should eq("(11)9123-4567")
    end
  end

  context "santander billet" do
    before(:each) do 
      MoIP::Client.stub(:checkout).and_return({ foo: "bar" })
      subject.stub(:santander_is_active).and_return true
      subject.stub(:from_olook_user).and_return true
      subject.payment = billet
    end

    describe "#send_to_gateway" do
      it "calls billet_payment" do
        subject.should_receive(:billet_payment)
        subject.send_to_gateway
      end

      it "doesn't hit Moip" do
        MoIP::Client.should_not_receive(:checkout)
        subject.send_to_gateway
      end
    end

    context "when deactivated" do
      before(:each) do 
        subject.stub(:santander_is_active).and_return false
        subject.stub(:from_olook_user).and_return false
        subject.payment = billet
      end

      it "doesn't call billet_payment" do
        CartService.any_instance.stub(:freight).and_return(freight)
        subject.should_not_receive(:billet_payment)
        subject.send_to_gateway
      end

      it "hits Moip" do
        subject.stub(:payment_data).and_return({})
        MoIP::Client.should_receive(:checkout)
        subject.send_to_gateway
      end
    end

    describe "#billet_url" do
      it "returns the path to the billet, passing the payment id" do
        expect(subject.billet_url).to eql "/pagamento/boletos/#{subject.payment.id}"
      end
    end

    describe "#billet_payment" do
      context "Santander billet is enabled" do 
        before do
          subject.stub(:santander_is_active).and_return(true)
        end

        it "assigns the billet's url to the payment" do
          subject.billet_payment
          expect(subject.payment.url).to eql(subject.billet_url)
        end

        it "sets Olook (id=3) as gateway" do
          subject.billet_payment
          expect(subject.payment.gateway).to eql(3)
        end        

        it "sets the payment's gateway status to successful" do
          subject.billet_payment
          expect(subject.payment.gateway_response_status).to eql(Payment::SUCCESSFUL_STATUS)
        end

        it "saves the payment" do
          subject.payment.should_receive(:save!).and_return true
          subject.billet_payment
        end
      end
    end
  end
end
