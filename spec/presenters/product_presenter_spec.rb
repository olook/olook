# -*- encoding : utf-8 -*-
require "spec_helper"

describe ProductPresenter do
  let(:product) { FactoryGirl.create :basic_shoe }
  let(:template) { double :template }
  subject { described_class.new product, template }

  describe '#member_showroom' do
    it "should render the partial with the carousel with the member's showroom" do
      template.should_receive(:render).with(:partial => 'product/member_showroom', :locals => {:product_presenter => subject}).and_return('showroom')
      subject.member_showroom.should == 'showroom'
    end
  end

  describe '#render_related_products' do
    it "should render the partial with product's related products" do
      template.should_receive(:render).with(:partial => 'product/related_products', :locals => {:product_presenter => subject}).and_return('related')
      subject.render_related_products.should == 'related'
    end
  end

  describe '#render_description' do
    it "should render the partial with the product's description" do
      template.should_receive(:render).with(:partial => 'product/description', :locals => {:product_presenter => subject}).and_return('description')
      subject.render_description.should == 'description'
    end
  end

  describe '#render_add_to_cart' do
    it "should render the partial with controls to add the product to the cart" do
      template.should_receive(:render).with(:partial => 'product/add_to_cart', :locals => {:product_presenter => subject}).and_return('cart')
      subject.render_add_to_cart.should == 'cart'
    end
  end
  
  describe '#render_details' do
    it "should render the partial with the product details" do
      template.should_receive(:render).with(:partial => 'product/details', :locals => {:product_presenter => subject}).and_return('details')
      subject.render_details.should == 'details'
    end
  end
end
