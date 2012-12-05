require "spec_helper"

describe PaymentService do

  let(:olook_user) { FactoryGirl.create :user, {:email => "teste@olook.com.br"} }
  let(:non_olook_user) { FactoryGirl.create :user, {:email => "teste@teste.com"} }
  let(:payment) { FactoryGirl.create :credit_card}
  let(:cart) { FactoryGirl.create :clean_cart}

  context "when the braspag_whitelisted_only is false" do

    it "should redirect non olook users to braspag sender strategy" do
      Setting.stub(:braspag_whitelisted_only) { false }
      Setting.stub(:braspag_percentage) { 100 }
      cart.user = non_olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::BraspagSenderStrategy)
    end

    it "should redirect olook users to braspag sender strategy" do
      Setting.stub(:braspag_whitelisted_only) { false }
      Setting.stub(:braspag_percentage) { 100 }
      cart.user = olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::BraspagSenderStrategy)      
    end

    it "should redirect olook users to moip sender strategy" do
      Setting.stub(:braspag_whitelisted_only) { false }
      Setting.stub(:braspag_percentage) { 0 }
      cart.user = olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::MoipSenderStrategy)      
    end

    it "should redirect non olook users to moip sender strategy" do
      Setting.stub(:braspag_whitelisted_only) { false }
      Setting.stub(:braspag_percentage) { 0 }
      cart.user = non_olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::MoipSenderStrategy)      
    end

    context "percentage tests" do

      before do
        Setting.stub(:braspag_whitelisted_only) { false }
        Setting.stub(:braspag_percentage) { 50 }
      end

      it "should select Braspag to a non olook user as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 30 }
        cart.user = non_olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::BraspagSenderStrategy)        
      end

      it "should select Braspag to an on olook user as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 30 }
        cart.user = olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::BraspagSenderStrategy)        
      end

      it "should select Moip to a non olook user as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 60 }
        cart.user = non_olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::MoipSenderStrategy)
      end

      it "should select Moip to an olook user as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 60 }
        cart.user = olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::MoipSenderStrategy)
      end

    end    

  end

  context "when the braspag_whitelisted_only is true" do

    before do
      Setting.stub(:braspag_whitelisted_only) { true }
      Setting.stub(:braspag_percentage) { 60 }
    end

    it "should redirect olook users to braspag sender strategy" do
      Random.stub(:rand) { 50 }
      cart.user = olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::BraspagSenderStrategy)
    end

    it "should redirect olook users to moip sender strategy (if the random value > 60)" do
      Random.stub(:rand) { 70 }
      cart.user = olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::MoipSenderStrategy)
    end

    it "should redirect non olook users to moip sender strategy" do
      cart.user = non_olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::MoipSenderStrategy)
    end

    context "percentage tests" do

      before do
        Setting.stub(:braspag_percentage) { 50 }
      end

      it "should select Braspag as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 30 }
        cart.user = olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::BraspagSenderStrategy)        
      end

      it "should select Moip as we stub random to intentionally choose it, considering the given percentage" do
        Random.stub(:rand) { 60 }
        cart.user = olook_user
        cart_service = CartService.new({:cart => cart})
        sender = PaymentService.create_sender_strategy(cart_service, payment)
        sender.class.should eq(Payments::MoipSenderStrategy)
      end

    end

  end

  context "credit card banks" do
    let(:payment_hipercard) { FactoryGirl.create :credit_card, :bank => "Hipercard"}
    let(:payment_amex) { FactoryGirl.create :credit_card, :bank => "AmericanExpress"}
    let(:cart_service) { CartService.new({:cart => cart}) }

    it "should select Moip if bank is Hipercard" do
      sender = PaymentService.create_sender_strategy(cart_service, payment_hipercard)
      sender.class.should eq(Payments::MoipSenderStrategy)
    end

    it "should select Moip if bank is AmericanExpress" do
      sender = PaymentService.create_sender_strategy(cart_service, payment_amex)
      sender.class.should eq(Payments::MoipSenderStrategy)
    end
  end

end
