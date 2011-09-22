# -*- encoding : utf-8 -*-
require 'spec_helper'

feature "Products test", %q{
  As a tester
  I want to do a integration test
} do

  before :each do
  end

  scenario "In the Products page" do
    visit products_path
    page.should have_content("products")
  end

end