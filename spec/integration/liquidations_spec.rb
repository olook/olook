 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Liquidation", %q{
  In order to buy products with discounts
  As a user
  I want to see the liquidation products
  } do

  let!(:user) { Factory.create(:user) }
  let(:basic_shoe_size_35) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:liquidation) { FactoryGirl.create(:liquidation) }

  describe "Liquidation" do
    background do
      do_login!(user)
    end

    scenario "User can see the liquidation" do
      visit liquidations_path(liquidation)
      page.should have_content(liquidation.name)
    end

    scenario "User can search usign some filters" do
      lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteira")
      visit liquidations_path(liquidation)
      check("rasteira")
      page.should have_content(basic_shoe_size_35.product.name)
    end
  end
end
