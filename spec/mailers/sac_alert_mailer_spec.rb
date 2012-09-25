# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SACAlertMailer do
  include ActionView::Helpers::NumberHelper
  
  let(:variant) { FactoryGirl.create :basic_shoe_size_35, :retail_price => 20.0 }
  
  let(:order) { 
    order = FactoryGirl.create(:order) 
    order.line_items << (FactoryGirl.build :line_item, :variant => variant, :quantity => 2, :price => 20.0, :retail_price => 20.0)
    order
  }
  let(:to) { "sac@olook.com.br" }

  describe "#billet_notification" do
    subject { SACAlertMailer.billet_notification(order, to) }

    it "sets 'from' attribute to sac notifications <sac.notifications@olook.com.br>" do
      subject.from.should include("sac.notifications@olook.com.br")
    end

    it "sets 'to' attribute to passed to" do
      subject.to.should include(to)
    end

    it "should assign correct subject" do
      subject.subject.should eq("Pedido: #{order.number} | Boleto")
    end

    it "should contain user details (name, telephone, email)" do
      subject.body.should include(order.user_name)
      subject.body.should include(order.user_email)
      subject.body.should include(order.freight.telephone)
    end
    
    it "should contain order details (number, total discount, amount paid)" do
      subject.body.should include(order.number)
      subject.body.should include(number_to_currency(order.payments.with_discount.sum(:total_paid)))
      subject.body.should include(number_to_currency(order.amount_paid))
    end
    
    it "should contain line items details (picture, name, price, description)" do
      subject.body.should include(variant.showroom_picture)
      subject.body.should include(variant.name)
      subject.body.should include(number_to_currency(variant.price))
      subject.body.should include(variant.product.description)
    end
    
  end
end
