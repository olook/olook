# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Admin deletes a campaign" do

  before :each do
  	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  let!(:campaign) { FactoryGirl.create(:campaign) }

  scenario "in successfully scenario " do
    do_admin_login!(@admin)
    visit "/admin"
    click_link "Campaigns"
    expect(page).to have_content('First Campaign')
    click_link "Destroy"
    expect(page).to_not have_content('First Campaign')
  end
end

