# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartController do
  with_a_logged_user do
    render_views
    let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
    let(:product) { variant.product }

    describe "POST create" do
      before :each do
        @back = request.env['HTTP_REFERER'] = product_path(product)
      end

      context "with a valid @variant" do
        it "should create a Order" do
          expect {
            post :create, :variant => {:id => variant.id}
          }.to change(Order, :count).by(1)
        end

        it "should redirect back to product page" do
          post :create, :variant => {:id => variant.id}
          response.should redirect_to(product_path(product))
        end

        it "should add a variant in the order" do
          Order.any_instance.should_receive(:add_variant).with(variant).and_return(true)
          post :create, :variant => {:id => variant.id}
        end
      end

      context "with a invalid @variant" do
        it "should redirect back with a warning if the variant dont exists" do
          post :create, :variant => {:id => ""}
          response.should redirect_to(@back, :notice => "Selecione um produto")
        end

        it "should redirect back with a warning if the variant is not available" do
          Variant.any_instance.stub(:available?).and_return(false)
          post :create, :variant => {:id => ""}
          response.should redirect_to(@back, :notice => "Produto esgotado")
        end
      end
    end
  end
end

