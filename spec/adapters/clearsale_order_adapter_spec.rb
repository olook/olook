# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ClearsaleOrderAdapter do
  context "adapting a sample payment" do
    let(:user) { FactoryGirl.create(:user, :email => "teste@teste.com", :cpf => "60074548786", :last_sign_in_ip => "127.0.0.1", :birthday => '12/09/1976') }
    let(:address) { FactoryGirl.create(:address, :user => user) }
    let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
    let(:order) { FactoryGirl.create(:clean_order_credit_card, :user => user, :cart => cart) }
    let(:cart_item) {FactoryGirl.create(:cart_item, :cart => cart)}
    let(:adapter) {ClearsaleOrderAdapter.new(order.payments.first,"0000000000000002", Time.current)}

    it "should adapt the user data" do
      expected_user_data = {:email=>"teste@teste.com",
                            :id=>nil,
                            :cpf=>"60074548786",
                            :full_name=>"José Ernesto",
                            :birthdate=>"12/09/1976",
                            :phone=>"(35)3456-6849",
                            :gender=>"f",
                            :last_sign_in_ip=>"127.0.0.1"}
      result = adapter.adapt_user
      expected_user_data[:id] = result[:id]
      result.should eq expected_user_data
    end

    it "should adapt the payment data" do
      expected_payment_data = {:card_holder=>"User name",
                              :card_number=>"0000000000000002",
                              :card_expiration=>"12/11",
                              :card_security_code=>"187",
                              :acquirer=>"visa",
                              :amount=>12.34}

      adapter.adapt_payment.should eq expected_payment_data
    end

    it "should adapt the order data" do
      expected_order_data = {:id=>nil,
                             :paid_at=>adapter.paid_at,
                             :billing_address=>
                              {:street_name=>"Rua Exemplo Teste",
                               :number=>"12354",
                               :complement=>"ap 45",
                               :neighborhood=>"Centro",
                               :city=>"Rio de Janeiro",
                               :state=>"RJ",
                               :postal_code=>"87656-908"},
                             :shipping_address=>
                              {:street_name=>"Rua Exemplo Teste",
                               :number=>"12354",
                               :complement=>"ap 45",
                               :neighborhood=>"Centro",
                               :city=>"Rio de Janeiro",
                               :state=>"RJ",
                               :postal_code=>"87656-908"},
                             :installments=>1,
                             :total_items=>0.0,
                             :total_order=>12.34,
                             :items_count=>1,
                             :created_at=>adapter.created_at,
                             :order_items=>
                              [{:product=>
                                 {:id=>"35", :name=>"Chanelle", :category=>{:id=>1, :name=>"Sapato"}},
                                :price=> 0.0,
                                :quantity=>2}]}
      result = adapter.adapt_order
      expected_order_data[:id] = result[:id]

      result.should eq expected_order_data
    end

  end
end
