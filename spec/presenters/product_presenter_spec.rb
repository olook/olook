# -*- encoding : utf-8 -*-
require "spec_helper"

describe ProductPresenter do
  let(:product) { FactoryGirl.create :basic_shoe }
  let(:member) { double :user }
  let(:template) { double :template }
  subject { described_class.new template, :product => product, :member => member }

  describe "user showroom methods" do
    describe '#render_member_showroom' do
      it "should render the partial with the carousel with the member's showroom" do
        template.should_receive(:render).with(:partial => 'product/member_showroom', :locals => {:product_presenter => subject}).and_return('showroom')
        subject.render_member_showroom.should == 'showroom'
      end
    end
    
    it "#collection_name, should return the current collection name" do
      Date.stub_chain(:today, :month).and_return(4)
      subject.collection_name.should == 'Abril'
    end

    describe "#render_main_profile_showroom" do
      it "should render a list of product images with links to their pages" do
        products = [:product_a, :product_b]
        subject.member.should_receive(:main_profile_showroom).and_return(products)
        template.should_receive(:render).with(:partial => 'product/showroom_product', :collection => products, :as => :product)
        subject.render_main_profile_showroom
      end
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
  
  describe '#render_colors' do
    it "should render the partial with the product colors" do
      template.should_receive(:render).with(:partial => 'product/colors',  :locals => {:product => subject.product}).and_return('colors')
      subject.render_colors.should == 'colors'
    end
  end

  describe '#render_sizes' do
    it "should render the partial with the product sizes" do
      template.should_receive(:render).with(:partial => 'product/sizes', :locals => {:product_presenter => subject}).and_return('sizes')
      subject.render_sizes.should == 'sizes'
    end
  end
end
