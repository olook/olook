require 'spec_helper'
require 'integration/helpers'

feature "Admin user with business 1 role manages gift boxes", %q{
  As a business 1 I can create, edit and delete gift boxes
} do

  let(:gift_boxes) { [FactoryGirl.create(:gift_box)] }

  before :each do
  	@admin = FactoryGirl.create(:admin_business1)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  scenario "As a business1 user I should be allowed to see a list of gift boxes" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes"
    page.should have_content "Listando Gift Boxes Types"
    page.should have_content "Nome"
    page.should have_content "Ativo"
  end
end

