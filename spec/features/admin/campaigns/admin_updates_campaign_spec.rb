# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Admin updates a campaign" do

  before :each do
  	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  let!(:campaign) { FactoryGirl.create(:campaign) }

  scenario "with valid attributes" do
    do_admin_login!(@admin)
    visit "/admin"
    click_link "Campaigns"
    click_link "Edit"
    expect(page).to have_content('Editing Campaign')
    fill_in "campaign_title", with: "Campanha atualizada"
    click_on("Atualizar Campaign")
    expect(page).to have_content('Campanha atualizada')
    expect(page).to have_content('Campaign was successfully updated.')
  end
end

