 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Accessing my vitrine", "In order to see the products as a user" do
	include CarrierWave::Test::Matchers
 
	let!(:user) { Factory.create(:user) }
  let(:casual_profile) { FactoryGirl.create(:casual_profile) }
  let!(:casual_points) { FactoryGirl.create(:point, user: user, profile: casual_profile, value: 50) }

	let(:valid_image)   { File.join fixture_path, 'valid_image.jpg' }
  let(:invalid_image) { File.join fixture_path, 'invalid_image.txt' }

	let(:collection) { FactoryGirl.create(:collection) }
  let!(:shoe) { FactoryGirl.create(:basic_shoe, :collection => collection, :color_name => 'Black', :profiles => [casual_profile]) }
	let!(:shoe_a) { FactoryGirl.create(:basic_shoe_size_35, :product => shoe) }

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
      	save_and_open_page
      	debugger
        within("ol") do
          page.should have_xpath("//input[@id='quantity']")
        end
      end

    end

  end
end
