# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:product) { variant.product }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "#index" do
    it "should load and display the product" do
      get :index, :id => product.id
      assigns(:product).should == product
      response.should render_template(:index)
    end
  end
end
