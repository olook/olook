require "spec_helper"

describe PaymentService do

  let(:olook_user) { FactoryGirl.create :user, {:email => "teste@olook.com.br"} }
  let(:non_olook_user) { FactoryGirl.create :user, {:email => "teste@teste.com"} }
  let(:payment) { FactoryGirl.create :credit_card}
  let(:cart) { FactoryGirl.create :clean_cart}

  context "when the braspag_whitelisted_only is true" do

    before do
      Setting.stub(:braspag_whitelisted_only) { true }
    end

    it "should redirect olook users to braspag sender strategy" do
      cart.user = olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::BraspagSenderStrategy)
    end

    it "should redirect non olook users to moip sender strategy" do
      cart.user = non_olook_user
      cart_service = CartService.new({:cart => cart})
      sender = PaymentService.create_sender_strategy(cart_service, payment)
      sender.class.should eq(Payments::MoipSenderStrategy)
    end

  end

  context "" do

    before do
    end

    it "should select Braspag as we stub random to intentionally choose it, considering the given percentage" do
    end

    it "should select Moip as we stub random to intentionally choose it, considering the given percentage" do
    end

  end

end
