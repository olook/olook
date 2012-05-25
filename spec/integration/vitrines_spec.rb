 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Accessing my vitrine", "In order to see the products as a user" do
  include CarrierWave::Test::Matchers

  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_info) { FactoryGirl.create(:user_info, user: user) }
  let(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let!(:casual_points) { FactoryGirl.create(:point, user: user, profile: casual_profile, value: 50) }

  let(:collection) { FactoryGirl.create(:collection) }
  let!(:shoe) { FactoryGirl.create(:basic_shoe, :collection => collection, :color_name => 'Black', :profiles => [casual_profile]) }
  let!(:shoe_a) { FactoryGirl.create(:basic_shoe_size_35, :product => shoe, :inventory => 1) }
  let!(:shoe_b) { FactoryGirl.create(:basic_shoe_size_37, :product => shoe, :inventory => 1) }

  let(:collection) { FactoryGirl.create(:collection) }
  let!(:shoe) { FactoryGirl.create(:basic_shoe, :collection => collection, :color_name => 'Black', :profiles => [casual_profile]) }
  let!(:shoe_a) { FactoryGirl.create(:basic_shoe_size_35, :product => shoe, :inventory => 1) }
  let!(:shoe_b) { FactoryGirl.create(:basic_shoe_size_37, :product => shoe, :inventory => 1) }

  context "My vitrine" do
    background do
      do_login!(user)
    end

    context "In my vitrine page" do
      before :all do
      end

      before :each do
        visit member_showroom_path
      end

      scenario "I want to see the product" do
        page.should have_content(shoe.name)
      end

      scenario "The quantity for each size must be in a hidden field" do
        within("ol") do
          page.should have_xpath("//input[@id='quantity_#{shoe.id}']")
        end
      end
     scenario "The quantity of the product must be 1" do
        within("li") do
          page.should have_xpath("//input[@value='1']")
        end
      end
      scenario "The quantity of the product of size 37 must be 0" do
        within("li") do
          page.should have_xpath("//input[@value='0']")
        end
      end
    end
  end
end
