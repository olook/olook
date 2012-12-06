require 'spec_helper'

describe Admin::DiscountsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let(:searched_user) { FactoryGirl.create(:user, :email => 'test@email.com') }
    let(:user) { FactoryGirl.create(:user) }
    let(:search_param) { {"email_contains" => searched_user.email} }

    it "should search for a user using the search parameter" do
      get :index, :search => search_param

      assigns(:user_discounts).should_not include(user)
      assigns(:user_discounts).should include(searched_user)
    end
  end

end
