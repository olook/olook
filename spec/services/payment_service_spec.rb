require "spec_helper"

describe PaymentService do

  let(:user) { FactoryGirl.create :user, {:email => "teste@teste.com"} }
  let(:payment) { FactoryGirl.create :credit_card, {:user => user} }
  let(:cart) { FactoryGirl.create :clean_cart, {user: user} }

  it "should redirect non olook users to braspag sender strategy" do
    cart_service = CartService.new({:cart => cart})
    sender = PaymentService.create_sender_strategy(cart_service, payment)
    sender.class.should eq(Payments::BraspagSenderStrategy)
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
