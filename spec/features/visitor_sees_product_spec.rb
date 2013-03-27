 # -*- encoding : utf-8 -*-

require 'spec_helper'
require 'features/helpers'

feature "Visitor sees Products", %q{
  In order to ensure that all product partials are visible to visitor
  I want to access all 7 sections of the site
  To see if a product is present
} do

  scenario "Member Showroom" do

    casual_profile  =  FactoryGirl.create(:casual_profile, :with_points, :with_user)
    user            =  casual_profile.users.first
    collection      =  FactoryGirl.create(:collection)
    shoe            =  FactoryGirl.create(:shoe, :in_stock, collection: collection)
    bag             =  FactoryGirl.create(:bag, :in_stock, collection: collection)
    accessory       =  FactoryGirl.create(:basic_accessory, :in_stock, collection: collection)
    cloth           =  FactoryGirl.create(:simple_garment, :in_stock, collection: collection)

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

  scenario "Catalog Clothes" do
  end

  scenario "Catalog Shoes" do
    collection_theme = FactoryGirl.create(:collection_theme)
    product = FactoryGirl.create(:shoe, :in_stock)
    product.variants.first.update_attributes(price: 169.99)
    catalog_product = FactoryGirl.create(:catalog_product, product: product, variant: product.variants.first)
    collection_theme.catalog.products << catalog_product

    visit '/sapatos'
    expect(page).to have_content('Sapatos')
    expect(page).to have_content(product.formatted_name)
    expect(page).to have_content(number_to_currency product.price)
    expect(page).to have_content(number_to_currency product.retail_price)
    expect(page).to have_content(product.brand)
  end

  scenario "Catalog Bags" do
  end

  scenario "Catalog Accessories" do
  end

  @javascript
  scenario "Gift index" do
    pending

    gift_box_helena = FactoryGirl.create(:gift_box_helena)
    gift_box_top_five = FactoryGirl.create(:gift_box_top_five)
    gift_box_hot_fb = FactoryGirl.create(:gift_box_hot_fb)

    visit "/presentes"
    #find("Veja as dicas da Helena").click
    binding.pry
    click_link("Veja as dicas da Helena")
    expect(page).to have_content(gift_box_helena.products.first.name)

  end

  scenario "Collection Theme" do
    collection_theme = FactoryGirl.create(:collection_theme)
    product = FactoryGirl.create(:shoe, :in_stock)
    product.variants.first.update_attributes(price: 169.99)
    catalog_product = FactoryGirl.create(:catalog_product, product: product, variant: product.variants.first)
    collection_theme.catalog.products << catalog_product

    visit collection_theme_path(slug: collection_theme.slug)

    expect(page).to have_content(product.formatted_name)
    expect(page).to have_content(number_to_currency product.price)
    expect(page).to have_content(number_to_currency product.retail_price)
    expect(page).to have_content(product.brand)
  end
end
