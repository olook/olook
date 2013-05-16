# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Admin deletes a campaign", feature: true, admin: true do

  before :each do
	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  let!(:campaign) { FactoryGirl.create(:campaign) }

  scenario "in successfully scenario " do
    do_admin_login!(@admin)
    visit "/admin"
    click_link "Campanhas"
    expect(page).to have_content('First Campaign')
    click_link "Apagar"
    expect(page).to_not have_content('First Campaign')
  end
end
