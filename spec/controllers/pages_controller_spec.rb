require 'spec_helper'

describe PagesController do

  describe "GET 'welcome'" do
    it "should be successful" do
      get 'welcome'
      response.should be_success
    end
  end

end
