require 'spec_helper'

describe Api::V1::ZipCodeController do

  let(:user) { FactoryGirl.create :user }
 
  before :each do
    sign_in user
  end

  describe "#show" do
    let(:cep) { FactoryGirl.create(:cep) }

    context "when the address is valid" do
      it "returns success status (201)" do
        get :show, id: cep.cep
        response.should be_success
      end

      it "returns the zip code data JSON" do
        get :show, id: cep.cep
        JSON.parse(cep.adapt_cep_to_address_hash.to_json).should eq(JSON.parse(response.body))
      end
    end

    context "when the zip code isn't valid" do
      it "returns not found status (404)" do
        get :show, id: ""
        response.status.should eq(404)
      end
    end

  end

end
