require 'spec_helper'

describe SessionsController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
	
  describe "Post 'create'" do
    it "should redirect to welcome page" do
      user = Factory(:user)	
      post :create, :user => { :email => user.email, :password => user.password }
      response.should redirect_to(welcome_url)
    end
  end

end
