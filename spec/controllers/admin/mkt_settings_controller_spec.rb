require 'spec_helper'

describe Admin::MktSettingsController, admin: true do
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end
  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create', settings: {"facebook_products" => "1703103190,1584034001,1525034002"}
      expect(response).to be_redirect
    end
  end

end
