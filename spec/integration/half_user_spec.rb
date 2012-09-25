require 'spec_helper'
require 'integration/helpers'

feature "Half user", %q{
  In order to buy products for a special person
  As a half user
  I want to be able to use olook
  } do

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }

  scenario "acessing as a half user must redirect to its root path" do
    half_user =  FactoryGirl.create(:user, :half_user => true, :gender => User::Gender[:male])
    do_login!(half_user)
    current_path.should == "/presentes"
    page.should_not have_content("Minha Vitrine")
  end

  scenario "acessing as a woman half user must redirect to its root path" do
    half_user = FactoryGirl.create(:user, :half_user => true, :gender => User::Gender[:female])
    do_login!(half_user)
    current_path.should =~ /vitrine/
    page.should have_content("Minha Vitrine")
  end
end
