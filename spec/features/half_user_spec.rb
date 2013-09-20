require 'spec_helper'
require 'features/helpers'

feature "Half user", %q{
  In order to buy products for a special person
  As a half user
  I want to be able to use olook
  } do

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
  let!(:gift_box_helena) { FactoryGirl.create(:gift_box_helena) }
  let!(:gift_box_top_five) { FactoryGirl.create(:gift_box_top_five) }
  let!(:gift_box_hot_fb) { FactoryGirl.create(:gift_box_hot_fb) }

  scenario "acessing as a half user must redirect to its root path" do
    half_user =  FactoryGirl.create(:user, :half_user => true, :gender => User::Gender[:male])
    do_login!(half_user)
    current_path.should == "/presentes"
  end

  scenario "acessing as a woman half user must redirect to its root path" do
    half_user = FactoryGirl.create(:user, :half_user => true, :gender => User::Gender[:female])
    do_login!(half_user)
    current_path.should =~ /vitrines/
    page.should have_content("Minha Vitrine")
  end
end
