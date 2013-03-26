 # -*- encoding : utf-8 -*-

require 'spec_helper'
require 'features/helpers'

feature "Visitor sees Products", %q{
  In order to ensure that all product partials are visible to visitor
  I want to access all 7 sections of the site
  To see if a product is present
} do

  let!(:casual_profile) { FactoryGirl.create(:casual_profile, :with_points, :with_user) }
  let!(:user) { casual_profile.users.first }
  let!(:collection) { FactoryGirl.create(:collection) }
  let!(:shoe) { FactoryGirl.create(:shoe, :in_stock, collection: collection) }
  let!(:bag)  { FactoryGirl.create(:bag, :in_stock, collection: collection) }
  let!(:accessory) { FactoryGirl.create(:basic_accessory, :in_stock, collection: collection) }
  let!(:cloth) { FactoryGirl.create(:simple_garment, :in_stock, collection: collection) }

  scenario "Member Showroom" do
    user.update_attribute(:password, '123456')
    user.update_attribute(:password_confirmation, '123456')

    casual_profile.products.push(shoe, bag, accessory, cloth)
    do_login!(user)

    visit "/"

    within("#clothes_container") do
      expect(page).to have_content('Suas roupas')
      expect(page).to have_content(cloth.formatted_name)
      expect(page).to have_content(cloth.brand)
      expect(page).to have_content(number_to_currency(cloth.price))
    end

    within("#shoes_container") do
      expect(page).to have_content('Seus sapatos')
      expect(page).to have_content(shoe.formatted_name)
      expect(page).to have_content(shoe.brand)
      expect(page).to have_content(number_to_currency(shoe.price))
    end

    within("#purse_container") do
      expect(page).to have_content('Suas bolsas')
      expect(page).to have_content(bag.formatted_name)
      expect(page).to have_content(bag.brand)
      expect(page).to have_content(number_to_currency(bag.price))
    end

    within("#accessories_container") do
      expect(page).to have_content('Seus acessórios')
      expect(page).to have_content(accessory.formatted_name)
      expect(page).to have_content(accessory.brand)
      expect(page).to have_content(number_to_currency(accessory.price))
    end
  end

  scenario "Lookbooks" do
  end

  scenario "Catalog Clothes" do
  end

  scenario "Catalog Shoes" do
  end

  scenario "Catalog Bags" do
  end

  scenario "Catalog Accessories" do
  end

  scenario "Gift index" do
  end

  scenario "Gift profiles" do
  end

  scenario "Gift quiz" do
  end
end
