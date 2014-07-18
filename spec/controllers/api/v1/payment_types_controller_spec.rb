require 'spec_helper'

describe Api::V1::PaymentTypesController do

  let(:user) { FactoryGirl.create :user }
 
  before :each do
    sign_in user
  end

  describe "#index" do
    it "returns successful status" do
      post :index
      expect(response.status).to eql 200
    end
    it "returns the payment types hash response" do
      post :index
      expect(response.body).to eql Api::V1::PaymentType.all.to_json
    end    
  end
end
