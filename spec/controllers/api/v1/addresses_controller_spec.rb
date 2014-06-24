require 'spec_helper'

describe Api::V1::AddressesController do

  let(:user) { FactoryGirl.create :user }
 
  before :each do
    sign_in user
  end

  describe "#create" do
 
    let(:address) { FactoryGirl.build(:address, :user => user) }

    context "when the address is valid" do
      it "returns success status (201)" do
        post :create, address: address.attributes
        response.should be_success
      end

      it "returns the address JSON" do
        post :create, address: address.attributes
        address.attributes.reject{|k,v| k == "id"}.should eq(JSON.parse(response.body).reject{|k,v| k == "id"})
      end
    end

    context "when the address isn't valid" do

      before do
        address.city = nil
      end

      it "returns unprocessable entity" do
        post :create, address: address.attributes
        response.status.should eq(422)
      end

      it "returns the errors JSON" do
        post :create, address: address.attributes
        JSON.parse(response.body).should_not be_empty 
      end
    end    
  end

  describe "#update" do
    let(:address) { FactoryGirl.create(:address, :user => user) }

    before do
      address.city = "Teresópolis"
    end

    context "when the address is valid" do
      it "returns success status (201)" do
        put :update, address: address.attributes, id: address.id
        response.should be_success
      end

      it "returns the updated address JSON" do
        post :update, address: address.attributes, id: address.id
        address.attributes.should eq(JSON.parse(response.body))
      end
    end

    context "when the address isn't valid" do
      before do
        address.city = nil
      end

      it "returns unprocessable entity" do
        put :update, address: address.attributes, id: address.id
        response.status.should eq(422)
      end

      it "returns the errors JSON" do
        put :update, address: address.attributes, id: address.id
        JSON.parse(response.body).should_not be_empty
      end
    end        

  end

  describe "#destroy" do

    context "when the address is valid" do
      let(:address) { FactoryGirl.create(:address, :user => user) }

      it "returns success status (201)" do
        delete :destroy, id: address.id
        response.should be_success
      end

      it "returns the updated address JSON" do
        delete :destroy, id: address.id
        response.body.should be_blank
      end

      it "deletes the address" do
        delete :destroy, id: address.id
        Address.where(address.attributes).should be_empty
      end
    end
  end

  describe "#index" do
    context "when there are addresses for the given user" do

      it "returns success status (201)" do
        get :index
        response.should be_success
      end

      it "returns the updated address list JSON" do
        FactoryGirl.create(:address, :user => user)
        FactoryGirl.create(:address, :user => user, :city => "Sao Paulo")
        user.reload
        get :index
        user.addresses.to_json.should eq(response.body)
      end
    end    

    context "when there aren't any addresses for the given user" do

      it "returns success status (201)" do
        get :index
        response.should be_success
      end

      it "returns an empty JSON list" do
        get :index
        response.body.should eq("[]")
      end
    end    

  end

  describe "#show" do
    let(:address) { FactoryGirl.create(:address, :user => user) }

    context "when the address is valid" do
      it "returns success status (201)" do
        get :show, address: address.attributes, id: address.id
        response.should be_success
      end

      it "returns the address JSON" do
        get :show, address: address.attributes, id: address.id
        address.attributes.should eq(JSON.parse(response.body))
      end
    end

    context "when the address isn't valid" do
      it "returns file not found status (404)" do
        get :show, id: -1
        response.status.should eq(404)
      end
    end    

  end

end
