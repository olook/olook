# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartBuilder do
  let(:variant) { FactoryGirl.create(:basic_shoe_size_35) }

  xit "should build gift session"

  context "build offline session" do
    it "should return cart_path" do
      controller = double(Users::RegistrationsController)
      path = mock
      controller.stub(:session).and_return({})
      controller.stub(:cart_path).and_return(path)
      CartBuilder.offline(controller).should be(path)
    end
    
    it "should add variant to order" do
      controller = double(Users::RegistrationsController)

      hash_session = {:offline_variant => { "id" => variant.id } }
      
      controller.stub(:session).and_return(hash_session)
      controller.stub(:cart_path).and_return(nil)
      
      order = double(Order)
      order.should_receive(:add_variant).with(variant)
      
      controller.stub(:current_order).and_return(order)
      
      expect {
        CartBuilder.offline(controller)
      }.to_not raise_error
      
      hash_session[:offline_variant].should be_nil
    end
  end
end