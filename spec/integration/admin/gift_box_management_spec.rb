require 'spec_helper'
require 'integration/helpers'

feature "Admin user with business 1 role manages gift boxes", %q{
  As a business 1 I can create, edit and delete gift boxes
} do


  before :each do
  	@admin = FactoryGirl.create(:admin_business1)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  scenario "As a sac_operator I should not be allowed to destroy a collection" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes"
  end 

end

