require 'spec_helper'

describe Api::V1::FreightsController do

  describe "#show" do
    context "when missing params" do
      context " - all" do
        it "returns falure status" do
          post :show
          expect(response.status).to eql 422
        end
      end
      context " - zip_code" do
        it "returns falure status" do
          post :show, amount_value: "79.9"
          expect(response.status).to eql 422
        end
      end
      context " - amount_value" do
        it "returns falure status" do
          post :show, zip_code: "08730-810"
          expect(response.status).to eql 422
        end
      end
    end
    context "When invalid zip_code" do
      it "return error response" do
        post :show, zip_code: "087", amount_value: "79.9"
        expect(response.status).to eql 422
      end
    end
    context "when with correct params" do
      it "return ok status" do
        post :show, zip_code: "08730-810", amount_value: "79.9"
        expect(response.status).to eql 200
      end
      it "return correct hash keys" do
        post :show, zip_code: "08730-810", amount_value: "79.9"
        JSON.parse(response.body).has_key?([:default_shipping,:fast_shipping])
      end
    end
  end
end
