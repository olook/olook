require 'spec_helper'

describe StylistsController do
  let (:products) { [:product_a, :product_b] }
  describe "GET 'helena_linhares'" do
    context "without a logged user" do
      it "should be successful" do
        Product.stub(:find).and_return(products)
        get 'helena_linhares'
        response.should be_success
      end
    end
  end
end
