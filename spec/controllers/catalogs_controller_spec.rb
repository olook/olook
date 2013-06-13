require 'spec_helper'

describe CatalogsController do

  describe "GET 'shoe'" do
    it "returns http success" do
      get 'shoe'
      response.should be_success
    end
  end

  describe "GET 'bag'" do
    it "returns http success" do
      get 'bag'
      response.should be_success
    end
  end

  describe "GET 'cloth'" do
    it "returns http success" do
      get 'cloth'
      response.should be_success
    end
  end

  describe "GET 'accessory'" do
    it "returns http success" do
      get 'accessory'
      response.should be_success
    end
  end

end
