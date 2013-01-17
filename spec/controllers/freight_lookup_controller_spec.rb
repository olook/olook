require 'spec_helper'

describe FreightLookupController do

  describe "GET 'freight_price'" do
    it "returns http success" do
      get 'freight_price'
      response.should be_success
    end
  end

end
