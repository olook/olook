require 'spec_helper'
require 'integration/helpers'

feature "Admin user with business 1 role manages gift boxes", %q{
  As a business 1 I can create, edit and delete gift boxes
} do

  let(:admin) { FactoryGirl.create(:admin_business1) }

  background do
    do_admin_login!(admin)
    save_and_open_page
  end

  scenario "As a sac_operator I should not be allowed to destroy a collection" do

    visit "/admin/gift_boxes"
  end

end

