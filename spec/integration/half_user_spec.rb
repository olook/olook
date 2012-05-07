require 'spec_helper'
require 'integration/helpers'

feature "Half user", %q{
  In order to buy products for a special person
  As a half user
  I want to be able to use olook
  } do
    
  let!(:half_user) { FactoryGirl.create(:user, :half_user => true, :gender => 1) }
    
  scenario "acessing as a half user must redirect to its root path" do
    do_login!(half_user)
    current_path.should == "/gift"
    page.should_not have_content("Minha vitrine")
  end
    
end