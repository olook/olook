require 'spec_helper'

describe User::SettingsController do
  let(:user) { FactoryGirl.create :user }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET facebook" do
    it "should render the facebook settings page" do
      get :facebook
      response.should be_success
    end
  end
end
