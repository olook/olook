# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OrderStatusMailer do
  let(:user) { FactoryGirl.create(:user) }
  let!(:freight){FactoryGirl.create(:freight)}
  let(:order) {
    FactoryGirl.create(:order, :with_billet, :user => user, :amount_discount => 10.12, :freight => freight, :gift_wrap => true)
  }

  let!(:line_item_1){FactoryGirl.create(:line_item, order: order, variant: variant_1, price: 124.20, retail_price: 124.19)}
  let!(:variant_1){FactoryGirl.create(:basic_shoe_size_37)}
  let!(:line_item_2){FactoryGirl.create(:line_item, order: order, price: 124.18, retail_price: 79.9, variant: variant_2)}
  let!(:variant_2){FactoryGirl.create(:basic_shoe_size_37_with_discount)}

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }

  describe "#order_requested" do

    before do
      order.state = "waiting_payment"
      order.save!
    end

    let!(:mail) {
      OrderStatusMailer.order_requested(order)
    }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(user.email)
    end

    it { mail.body.should include(order.number)}
    it { mail.body.should include("Olá #{order.user.first_name}")}
    it { mail.body.should include(line_item_1.variant.product.formatted_name) }
    it { mail.body.should include(line_item_2.variant.product.formatted_name) }
    it { mail.body.should include(number_to_currency(line_item_1.retail_price)) }    
    it { mail.body.should include(number_to_currency(line_item_2.retail_price)) }
    it { mail.body.should include("- #{number_to_currency(order.amount_discount)}") }
    it { mail.body.should include(number_to_currency(order.freight_price)) }
    it { mail.body.should include(number_to_currency(CartService.gift_wrap_price)) }
    it { mail.body.should include(number_to_currency(order.amount_paid)) }

    it { mail.body.should_not include(number_to_currency(line_item_1.price)) }
    it { mail.body.should_not include(number_to_currency(line_item_2.price)) }

    context "for CreditCard" do

      let(:credit_card) {FactoryGirl.create(:clean_order_credit_card, :user => user)}
      let(:mail) { OrderStatusMailer.order_requested(credit_card) }

      it "sets 'subject' attribute telling the user that we received her order" do
        mail.subject.should == "José, recebemos seu pedido."
      end
      it { mail.body.should include("Por enquanto, estamos apenas aguardando a autorização da administradora do seu cartão de crédito.") }
    end

    context "for Debit" do

      let(:debit_order) {
        FactoryGirl.create(:order, :with_debit, :user => user, :amount_discount => 10.12, :freight => freight, :gift_wrap => true)
      }
      let(:mail) { OrderStatusMailer.order_requested(debit_order) }

      it "sets 'subject' attribute telling the user that we received her order" do
        mail.subject.should == "José, recebemos seu pedido."
      end
      it { mail.body.should include("Por enquanto, estamos apenas aguardando a autorização do seu banco.") }
    end

    context "for Billet" do
      it "sets 'subject' attribute telling the expiration date" do
        expiration_date =  I18n.l(order.get_billet_expiration_date, format: "%d/%m/%Y")
        mail.subject.should == "Lembrete: seu boleto expira em: #{expiration_date}. Garanta seu pedido!"
      end

      it { mail.body.should include("IMPRIMIR BOLETO") }
            
    end


  end

  describe "#payment_confirmed" do

    before do
      order.state = "authorized"
      order.save!
    end

    let!(:mail) { OrderStatusMailer.order_requested(order) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(user.email)
    end

    it "sets 'subject' attribute telling the user that the payment was confirmed" do
      mail.subject.should == "Seu pedido n#{order.number} foi confirmado!"
    end

  end

  describe "#payment_refused" do
    let(:cart) {FactoryGirl.create(:clean_cart)}
    let!(:order) { FactoryGirl.create(:clean_order_credit_card, :user => user, :cart => cart)}

    before do
      order.state = "canceled"
      order.save!
    end

    let!(:mail) { OrderStatusMailer.payment_refused(order) }

    it "sets 'from' attribute to olook <avisos@olook.com.br>" do
      mail.from.should include("avisos@olook.com.br")
    end

    it "sets 'to' attribute to passed member's email" do
      mail.to.should include(user.email)
    end

    context "and order is canceled" do
      it "sets 'subject' attribute telling the user that the payment was confirmed" do
        OrderStatusMailer.payment_refused(order).subject.should == "Seu pedido n#{order.number} foi cancelado."
      end
    end

    context "and order is reversed" do
      before do
        order.state = "reversed"
        order.save!
      end
      it "sets 'subject' attribute telling the user that the payment was confirmed" do
        OrderStatusMailer.payment_refused(order).subject.should == "Seu pedido n#{order.number} foi cancelado."
      end
    end

  end

  describe "#order_shipped" do
    before do
      order.state = "delivering"
      order.save!
    end
    let(:order) {
      FactoryGirl.create(:order, :with_billet, :user => user, :amount_discount => 10.12, :freight => freight, :gift_wrap => true, :expected_delivery_on => DateTime.now + 5.days)
    }

    let(:mail) {OrderStatusMailer.order_shipped(order)}

    it { mail.body.should include(order.user.first_name)}
    it { mail.subject.should eq("Seu pedido n#{order.number} foi enviado!")}
    it { mail.body.should include("CONVIDAR AGORA")}
    it { mail.body.should include("#{order.number}")}
    it { mail.body.should include(order.expected_delivery_on.strftime("%d/%m/%Y"))}
  end

  describe "#order_delivered" do
    before do
      order.state = "delivered"
      order.save!
    end
    let(:order) {
      FactoryGirl.create(:order, :with_billet, :user => user, :amount_discount => 10.12, :freight => freight, :gift_wrap => true, :expected_delivery_on => DateTime.now + 5.days)
    }

    let(:mail) {OrderStatusMailer.order_delivered(order)}
    it { mail.body.should include(order.user.first_name)}
    it { mail.subject.should eq("Seu pedido n#{order.number} foi entregue!")}
    it { mail.body.should include("CONVIDAR AGORA")}
    it { mail.body.should include("#{order.number}")}
  end

end
