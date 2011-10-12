require 'spec_helper'

describe Admin::IndexController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'dashboard'
      response.should be_success
    end
  end

end
