require 'spec_helper'

describe LookbooksController do
  describe "GET 'flores'" do
    context "without a logged user" do
      it "should be successful" do
        get 'flores'
        response.should be_success
      end
    end
  end
end
