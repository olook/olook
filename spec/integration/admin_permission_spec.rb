require 'spec_helper'
require 'integration/helpers'

feature "Admin user with sac_operator role executing actions on the system", %q{
  As a sac operator I should be able only to perform actions that i am allowed to
} do

  before :all do
    @admin = Factory.create(:admin_sac_operator)
    @collection = Factory.create(:inactive_collection)
  end

  scenario "As a sac_operator I shouldnt be able to list all roles in the system" do
    do_admin_login!(@admin)
    visit admin_roles_path
    page.should have_content("Access Denied!")
  end

  scenario "As a sac_operator I want to list all collections" do
    do_admin_login!(@admin)
    visit admin_collections_path
    page.should have_content("Listing collections")
  end

  scenario "As a sac_operator I want to edit a collection" do
    do_admin_login!(@admin)
    visit edit_admin_collection_path(@collection)
    page.should have_content("Editing collection")
  end

  scenario "As a sac_operator I should not be allowed to destroy a collection" do
    do_admin_login!(@admin)
    visit admin_collections_path
    click_link "Destroy"
    page.should have_content("Access Denied!")
  end  


end