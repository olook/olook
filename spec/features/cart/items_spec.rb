# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Handling cart items", %q{
  In order to make an order
  As a site visitor
  I want to add or remove items to/from my cart
} do 

  before(:each) do
    FakeWeb.register_uri(:any, /facebook/, :body => "")
    FakeWeb.register_uri(:any, /olark/, :body => "")
  end

  scenario "Adding an item to the cart", js: true do
    product = FactoryGirl.create(:blue_sliper_with_two_variants)
    product.master_variant.update_attribute(:inventory, 10) 

    visit product_path(product)
    choose("variant_id_#{product.variants.last.id}")
    within("form#product_add_to_cart") do
      find('input[type=submit]').click
    end

    sleep(1)
    
    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (1)'
    end
  end 

  scenario "Removing an item from the cart" do
    pending("WIP")
    cart = FactoryGirl.create(:cart_with_items)
    #TODO: find a way for not having to stub this for CartController#find_suggested_product
    Product.stub(:find).with(Setting.checkout_suggested_product_id.to_i).and_return(nil)
    
    ApplicationController.any_instance.stub(:current_cart).and_return(cart)

    visit "/sacola"

    save_and_open_page
    
    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (1)'
    end

    within('form#remove_item_form') do
      find('input[type=submit]').click
    end

    sleep(1)

    page.content.should contain('Produto excluído com sucesso')

    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (0)' 
    end
  end

end
