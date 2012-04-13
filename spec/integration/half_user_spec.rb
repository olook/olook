require 'spec_helper'
require 'integration/helpers'

feature "Half user", %q{
  In order to buy products for a special person
  As a half user
  I want to be able to use olook
  } do
    
  let!(:half_user) { Factory.create(:user, :half_user => true) }
    
  scenario "acessing as a half user must redirect to its root path" do
    do_login!(half_user)
    current_path.should == "/gift"
  end
    
end