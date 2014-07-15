require 'spec_helper'

describe Api::V1::PaymentTypesController do
  describe "#index" do
    it "returs successful code" do
      post :index
      expect(response.status).to eql 200
    end
  end
end
