 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Navigating by Catalog Shoe", %q{
  In order to simulate a user experience
  I want to be able to see all the shoes in catalog
  When visiting link "Shoe"
  } do

  describe "Navigating" do
    before(:each) do
      collection_theme = FactoryGirl.create(:collection_theme, { name: "work", slug: "work", id: 1 })
      shoe = (FactoryGirl.create :shoe_subcategory_name).product
      shoe.update_attributes(name: "Never SHOE")
      FactoryGirl.create :shoe_heel, product: shoe
      FactoryGirl.create :basic_shoe_size_35, product: shoe, :inventory => 7
      FactoryGirl.create :basic_shoe_size_37, product: shoe, :inventory => 5
      shoe.master_variant.price = 100.00
      shoe.master_variant.save!

      bag = (FactoryGirl.create :bag_subcategory_name).product
      bag.update_attributes(name: "Mac Lovin BAG")
      bag.master_variant.price = 100.00
      bag.master_variant.save!
      FactoryGirl.create :basic_bag_simple, product: bag

      accessory = (FactoryGirl.create :accessory_subcategory_name).product
      accessory.update_attributes(name: "I LOVE NEW YORK BADGE")
      accessory.master_variant.price = 100.00
      accessory.master_variant.save!
      FactoryGirl.create :basic_accessory_simple, product: accessory

      CatalogProductService.new(collection_theme.catalog, accessory).save!
      CatalogProductService.new(collection_theme.catalog, bag).save!
      CatalogProductService.new(collection_theme.catalog, shoe).save!
    end

    scenario "visiting shoes link" do
      visit home_url
      within('.menu_new') do
        click_link "Sapatos"
      end
      expect(page).to have_content("Sapatos mais vendidos")
      expect(page).to_not have_content("Mac Lovin BAG")
      expect(page).to have_content("Never SHOE")
      expect(page).to_not have_content("I LOVE NEW YORK BADGE")
    end

    scenario "visiting bag link" do
      visit home_url
      within('.menu_new') do
        click_link "Bolsas"
      end
      expect(page).to have_content("Bolsas mais vendidas")
      expect(page).to have_content("Mac Lovin BAG")
      expect(page).to_not have_content("Never SHOE")
      expect(page).to_not have_content("I LOVE NEW YORK BADGE")
    end

    scenario "visiting accessory link" do
      visit home_url
      within('.menu_new') do
        click_link "Acessórios"
      end
      expect(page).to have_content("Acessorios mais vendidos")
      expect(page).to_not have_content("Mac Lovin BAG")
      expect(page).to_not have_content("Never SHOE")
      expect(page).to have_content("I LOVE NEW YORK BADGE")
    end
  end
end
