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
    let(:search) { searched_user.email }

    it "should search for a user using the search parameter" do
      discount_start = (searched_user.campaign_email_created_at ? searched_user.campaign_email_created_at : searched_user.created_at)
      discount_period = Setting.discount_period_in_days.to_i.days

      searched_user_response = OpenStruct.new(email: searched_user.email, name: searched_user.name, discount_start: searched_user.created_at.beginning_of_day, discount_end: (searched_user.created_at + discount_period).end_of_day, used_discount:false)

      get :index, email: search
      assigns(:user_discounts).should_not include(user)
      assigns(:user_discounts).should include(searched_user_response)
    end

    it "returns an empty array " do
      get :index
      assigns(:user_discounts).should eq([])
    end

  end

end
