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
    
  end
end

