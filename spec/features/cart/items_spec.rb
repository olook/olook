# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Handling cart items", %q{
  In order to make an order
  As a site visitor
  I want to add or remove items to/from my cart
} do 

  before(:each) do 
    FakeWeb.register_uri(:any, /facebook/, :body => "")
    FakeWeb.register_uri(:any, /olark/, :body => "")
    FakeWeb.register_uri(:any, /campaign_emails/, :body => "")
  end

  scenario "Adding an item to the cart", js: true do
    product = FactoryGirl.create(:blue_sliper_with_two_variants)
    product.master_variant.update_attribute(:inventory, 10) 

    visit product_path(product.id)
    
    within('p.new_sacola') do
      find('a.cart').text.should == 'MINHA SACOLA (0 itens)'
    end

    choose("variant_id_#{product.variants.last.id}")

    within("form#product_add_to_cart") do
      find('input[type=submit]').click
    end

    sleep(1)
    
    within('p.new_sacola') do
      find('a.cart').text.should == 'MINHA SACOLA (1 item)'
    end
  end  


  scenario "Removing an item from the cart", js: true do 
    pending
    cart = FactoryGirl.create(:cart_with_one_item)  
    
    Checkout::CartController.any_instance.stub(:load_cart).and_return(cart)
    Checkout::CartController.any_instance.stub(:current_cart).and_return(cart)
    Checkout::CartController.any_instance.stub(:erase_freight)
    Checkout::CartController.any_instance.stub(:find_suggested_product)
    Checkout::CartController.any_instance.stub(:load_coupon)
    Checkout::CartController.any_instance.stub(:current_referer)

    visit "/sacola" 
    
    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (1)'
    end

    within('form#remove_item_form_1') do
      find('input[type=submit]').click
    end
    # save_and_open_page

    sleep(1)  

    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (0)' 
    end
  end

  scenario "Updating an item's quantity", js: true do
    pending
    cart = FactoryGirl.create(:cart_with_one_item) 
    
    Checkout::CartController.any_instance.stub(:current_cart).and_return(cart)
    Checkout::CartController.any_instance.stub(:erase_freight)
    Checkout::CartController.any_instance.stub(:find_suggested_product)

    visit "/sacola"

    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (1)'
    end

    within("form#change_amount_#{cart.items.first.id}") do
      select('2')
    end

    sleep(1)

    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (2)' 
    end

  end

end
