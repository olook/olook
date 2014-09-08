require 'spec_helper'

describe Api::V1::FreightsController do

  describe "#index" do
    context "when missing params" do
      context " - all" do
        it "returns falure status" do
          post :index
          expect(response.status).to eql 422
        end
      end
      context " - zip_code" do
        it "returns falure status" do
          post :index, amount_value: "79.9"
          expect(response.status).to eql 422
        end
      end
      context " - amount_value" do
        it "returns falure status" do
          post :index, zip_code: "08730-810"
          expect(response.status).to eql 422
        end
      end
    end
    context "When invalid zip_code" do
      it "return error response" do
        post :index, zip_code: "087", amount_value: "79.9"
        expect(response.status).to eql 422
      end
    end
    context "when with correct params" do
      it "return ok status" do
        post :index, zip_code: "08730-810", amount_value: "79.9"
        expect(response.status).to eql 200
      end

      it "return two freights with default and fast kind" do
        FreightService::TransportShippingManager.any_instance.should_receive(:api_hash).and_return([
          { kind: 'default', price: 20, cost: 15, delivery_time: 6, shipping_service_id: 2},
          { kind: 'fast', price: 30, cost: 20, delivery_time: 2, shipping_service_id: 1}
        ])
        post :index, zip_code: "08730-810", amount_value: "79.9"
        freights = JSON.parse(response.body)
        expect(freights.size).to eq(2)
        expect(freights.any? { |f| f['kind'] == 'default'}).to be
        expect(freights.any? { |f| f['kind'] == 'fast'}).to be
      end
    end
  end
end
