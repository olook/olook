 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Navigating by moments", %q{
  In order to simulate a user experience
  I want to be able to see the correct product related to each moment
  } do
    
  let!(:user) { FactoryGirl.create(:user) }
  let!(:day_moment) { FactoryGirl.create(:moment) }
  let!(:work_moment) { FactoryGirl.create(:moment, { :name => "work", :slug => "work" }) }
  
  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  let(:basic_shoes) do

    product = (FactoryGirl.create :shoe_subcategory_name).product

    FactoryGirl.create :shoe_heel, :product => product
    FactoryGirl.create :basic_shoe_size_35, :product => product, :inventory => 7
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 5

    product.master_variant.price = 100.00
    product.master_variant.save!

    product
  end
    
  describe "Already user" do
    background do
      do_login!(user)
    end
    
    scenario "visiting the moment page/home" do
      visit moments_path
      within(".moments") do
          page.should have_xpath("//a[@class='selected']")
      end
    end
    
    describe "checking products at the related moment" do
      
      before :each do 
        CatalogProductService.new(day_moment.catalog, basic_bag).save!
        CatalogProductService.new(work_moment.catalog, basic_shoes).save!
        visit moments_path
      end

      scenario "product should be in the actual moment" do
        page.should have_content( basic_bag.name )
      end

      scenario "changing moment and checking if product are being showed" do
        click_link "work"
        page.should have_content( basic_shoes.name )
      end

    end  
  
  end
end
