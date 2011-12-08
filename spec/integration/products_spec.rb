# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Buying products", %q{
  In order to buy products
  As a user
  I want to build a look
} do

  let(:user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create :basic_shoe }
  let!(:variant_a) { FactoryGirl.create(:basic_shoe_size_35, :product => product) }

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
      context "and the product has more than one variant" do
        let!(:variant_b) { FactoryGirl.create(:basic_shoe_size_40, :product => product) }
        scenario "I need to choose the variant and then add it to the cart" do
          visit product_path(product)
          choose variant_a.number
          click_button "add_product"
          page.should have_content("Produto adicionado com sucesso")
        end
        scenario "If I don't choose a variant and try to add it to the cart, it should tell me I need to pick a size" do
          visit product_path(product)
          click_button "add_product"
          page.should have_content("Selecione um tamanho")
        end
      end

      context "and the product has only one variant" do
        scenario "just need to click 'add to the cart'" do
          visit product_path(product)
          click_button "add_product"
          page.should have_content("Produto adicionado com sucesso")
        end
      end
    end
  end
end
