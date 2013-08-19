require 'spec_helper'

describe ProfilesController do

  describe "GET 'show'" do
    with_a_logged_user do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end
  end
end
