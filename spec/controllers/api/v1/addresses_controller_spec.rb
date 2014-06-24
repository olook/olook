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
        address.attributes.reject{|k,v| k == "id"}.should eq(JSON.parse(response.body).reject{|k,v| k == "id"})
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
      # let(:address) { FactoryGirl.create(:address, :user => user) }

      # it "returns success status (201)" do
      #   delete :destroy, id: address.id
      #   response.should be_success
      # end

      # it "returns the updated address JSON" do
      #   delete :destroy, id: address.id
      #   address.attributes.reject{|k,v| k == "id"}.should eq(JSON.parse(response.body).reject{|k,v| k == "id"})
      # end
    end
  end

  describe "#index" do
  end

  describe "#show" do
  end

end
