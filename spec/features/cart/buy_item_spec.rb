# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Complete on order", %q{
  When I complete one buy
  As a new user
  I want see order with correct descount
} do
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
  let(:promotion) {FactoryGirl.create(:first_time_buyers)}


  scenario "ending one buy" do
    pending
    user = FactoryGirl.create(:user, first_name: "john", cpf: "32856036821")
    cart = FactoryGirl.create(:cart_with_one_item, user: user)
    address = FactoryGirl.create(:address, user: user)
    Checkout::CartController.any_instance.stub(:find_suggested_product).and_return(nil)
    Checkout::CartController.any_instance.stub(:erase_freight)
    ApplicationController.any_instance.stub(:current_cart).and_return(cart)
    #PaymentBuilder.any_instance.stub(:process!).and_return(PaymentBuilder.new)
    PaymentBuilder.any_instance.stub(:status).and_return(Payment::SUCCESSFUL_STATUS)


    do_login!(user)

    page.should have_content("Olá, john")

    visit '/sacola'

    current_path.should == "/sacola"

    within('li#cart') do
      find('a.cart').text.should == 'Minha Sacola (1)'
    end

    debugger

    within('td.buttons') do
      find('a.continue').click
    end
    current_path.should == "/sacola/pagamento/endereco"

    within('ul.links') do
      find('a.select_address').click
    end

    current_path.should == "/sacola/pagamento/credito"

    visit "/sacola/pagamento/boleto"

    page.should have_content("imprimir seu boleto")

    within('form#new_billet') do
      find('input[type=submit]').click
    end

    #save_and_open_page
    #debugger
    sleep(1)
    #within('p.thanks') do
      page.should have_content("Obrigada pela sua compra")
    #end

    cart.user.orders.should be_empty
  end


end
