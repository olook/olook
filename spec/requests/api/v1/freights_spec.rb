require 'spec_helper'

describe "Freights" do
  context "Missing params" do
    it "return falure response" do
      get '/api/v1/freights/123'
      expect(response.status).to eql 422
    end
    it "return falure response" do
      get '/api/v1/freights/123'
      expect(response.body).to eql 422
    end
  end
end
