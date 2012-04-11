require 'spec_helper'

describe Gift::RecipientsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "redirects_to gift_root_path" do
      post 'create'
      response.should redirect_to gift_root_path
    end
  end

  describe "POST 'update'" do
    it "returns http success" do
      post 'update'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

end
