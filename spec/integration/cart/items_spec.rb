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
    @product = FactoryGirl.create(:blue_sliper_with_two_variants)
    @product.master_variant.update_attribute(:inventory, 10) 
  end

  scenario "Adding an item to the cart", js: true do
    visit product_path(@product)
    choose("variant_id_#{@product.variants.last.id}")
    within("form#product_add_to_cart") do
      find('input[type=submit]').click
    end
    sleep(1)
    within('li#cart') do
      find('a.cart').text.should == 'MINHA SACOLA (1)'
    end
  end

  scenario "Removing an item from the cart" do
  end

end
