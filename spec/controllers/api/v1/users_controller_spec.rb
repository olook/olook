require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { FactoryGirl.build :user, cpf: "" }
  describe "#create" do
    context "On success" do
      it "returns successful status" do
        post :create, user: user.attributes
        expect(response.status).to eql 200
      end
      it "returns user json" do
        post :create, user: user.attributes
        expect(response.body).to eql user.to_json
      end
    end
    context "On failure" do
      before do
        user.first_name = nil
      end
      it "returns successful status" do
        post :create, user: user.attributes
        expect(response.status).to eql 422
      end
      it "returns user json error" do
        post :create, user: user.attributes
        error = JSON.parse(response.body)
        expect(error["first_name"][0]).to include("Queremos te conhecer, qual é o seu nome?")
        expect(error["first_name"][1]).to include("não é válido")
      end
    end
  end
end
