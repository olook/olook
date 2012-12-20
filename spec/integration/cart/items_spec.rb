# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Handling cart items", %q{
  In order to make an order
  As a site visitor
  I want to add or remove items to/from my cart
} do

  before(:each) do
    @product = FactoryGirl.create(:basic_shoe)
    @variant = FactoryGirl.create(:basic_shoe_size_35, :product => @product)  
  end

  scenario "Adding an item to the cart" do 
    pending "we have to find out a better way to run integration tests that use js"
    # , js: true do
    visit product_path(@product)
    choose @variant.number
    find('#add_product').click
    page.should have_content('MINHA SACOLA (1)')
  end

  scenario "Removing an item from the cart" do
  end

end
