# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Buying products", %q{
  In order to buy products
  As a user
  I want to build a look
} do

  let(:user) { FactoryGirl.create(:user) }
  let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:product) { variant.product }

  context "buying products" do

  background do
   do_login!(user)
  end

    context "in the products page" do
      scenario "I want to see product" do
        visit product_path(product)
        page.should have_content(product.name)
      end
    end

    context "with the shopping cart" do
      scenario "I want to add a product" do
        visit product_path(product)
        choose variant.number
        click_button "add_product"
        page.should have_content("Produto adicionado com sucesso")
      end
    end
  end
end
