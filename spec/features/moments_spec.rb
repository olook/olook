 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Navigating by moments", %q{
  In order to simulate a user experience
  I want to be able to see the correct product related to each moment
  } do

  let!(:user) { FactoryGirl.create(:user, :user_info => UserInfo.new) }
  let!(:collection_theme_group) { FactoryGirl.create(:collection_theme_group) }
  let!(:work_collection_theme) { FactoryGirl.create(:collection_theme, { :name => "work", :slug => "work", collection_theme_group: collection_theme_group }) }
  let!(:day_collection_theme) { FactoryGirl.create(:collection_theme, collection_theme_group: collection_theme_group) }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
  let!(:sesstind_product) {FactoryGirl.create(:shoe)}

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
      Setting.stub(:collection_section_featured_products).and_return("teste|#{sesstind_product.id}")
      do_login!(user)
    end

    scenario "visiting the collection theme page/home" do
      visit collection_themes_path
      within("#collections_content") do
          page.should have_xpath("//a[@class='selected']")
      end
    end

    scenario "see collection themes groups on page" do
      visit collection_themes_path
      page.should have_content(collection_theme_group.name)
    end

    scenario "see collection themes groups on page" do
      visit collection_themes_path
      page.should have_content(work_collection_theme.name)
      page.should have_content(day_collection_theme.name)
    end

    describe "checking products at the related collection theme" do

      before :each do
        CatalogProductService.new(day_collection_theme.catalog, basic_bag).save!
        CatalogProductService.new(work_collection_theme.catalog, basic_shoes).save!
        visit collection_themes_path
      end

      scenario "product should be on specific collection theme " do
        click_link "dia-a-dia"
        page.should have_content( basic_bag.name )
        click_link "work"
        page.should have_content( basic_shoes.name )
      end
    end
  end
end
