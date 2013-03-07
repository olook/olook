 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Accessing my vitrine", "In order to see a customized list of products according to my profile" do
  # include CarrierWave::Test::Matchers

  let!(:casual_profile) { FactoryGirl.create(:casual_profile, :with_points, :with_user) }
  let!(:user) { casual_profile.users.first }
  let!(:collection) { FactoryGirl.create(:collection) }
  let!(:shoe) { FactoryGirl.create(:shoe, :in_stock, collection: collection) }
  let!(:bag)  { FactoryGirl.create(:bag, :in_stock, collection: collection) }
  let!(:accessory) { FactoryGirl.create(:basic_accessory, :in_stock, collection: collection) }

  before(:each) do
    user.update_attribute(:password, '123456')
    user.update_attribute(:password_confirmation, '123456')

    casual_profile.products.push(shoe, bag, accessory)
  end

  scenario "Products list" do
    do_login!(user) 

    within("#shoes_container") do
      expect(page).to have_content('Seus sapatos')
      expect(page).to have_content(shoe.name)
    end

    within("#purse_container") do
      expect(page).to have_content('Suas bolsas')
      expect(page).to have_content(bag.name)
    end

    within("#accessories_container") do
      expect(page).to have_content('Seus acessórios')
      expect(page).to have_content(accessory.name)
    end
  end

  let(:sold_out_shoe) { FactoryGirl.create(:shoe, :sold_out) }
  let(:shoe_with_plenty_of_stock) { FactoryGirl.create(:shoe, :with_plenty_of_stock) }

  scenario "Shoes sorting by inventory" do
    pending
    do_login!(user) 

    within("#shoes_container .products_list .best ul") do
      within("li:first") do
        expect(page).to have_content(shoe_with_plenty_of_stock.name)
      end
    end
  end
end
