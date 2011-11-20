# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Buying products", %q{
  In order to buy products
  As a user
  I want add products in the shopping cart and buy it
} do

  let(:user) { FactoryGirl.create(:user) }
  let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:product) { variant.product }

  context "shopping cart" do
    background do
      do_login!(user)
    end

    scenario "adding products in the cart" do
      visit product_path(product)
      choose variant.number
      click_button "add_product"
      page.should have_content("Produto adicionado com sucesso")
    end
  end
end
