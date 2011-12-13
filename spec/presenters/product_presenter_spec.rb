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
      subject.stub(:related_products).and_return(:mock_related_products)
      template.should_receive(:render).with(:partial => 'product/related_products', :locals => {:related_products => :mock_related_products}).and_return('related')
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
      template.should_receive(:render).with(:partial => 'product/add_to_cart', :locals => {:product_presenter => subject, :product => product}).and_return('cart')
      subject.render_add_to_cart.should == 'cart'
    end
  end
  
  describe '#render_form_by_category' do
    it 'should render the group box with color and size for shoes' do
      subject.product.stub(:category).and_return(Category::SHOE)
      template.should_receive(:render).with(:partial => 'product/form_for_shoe', :locals => {:product_presenter => subject}).and_return('shoe_form')
      subject.render_form_by_category.should == 'shoe_form'
    end
    it 'should render the group box with color and a hidden field with the variant for bags' do
      subject.product.stub(:category).and_return(Category::BAG)
      template.should_receive(:render).with(:partial => 'product/form_for_bag', :locals => {:product_presenter => subject}).and_return('shoe_form')
      subject.render_form_by_category.should == 'shoe_form'
    end
    it 'should render just the hidden field with the variant for accessories' do
      subject.product.stub(:category).and_return(Category::ACCESSORY)
      template.should_receive(:render).with(:partial => 'product/form_for_accessory', :locals => {:product_presenter => subject}).and_return('shoe_form')
      subject.render_form_by_category.should == 'shoe_form'
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

  describe '#render_single_size' do
    before :each do
      subject.product.stub_chain(:variants, :sorted_by_description).and_return([:single_variant])
    end
    it 'should render just a hidden field with the variant' do
      template.should_receive(:render).with(:partial => 'product/single_size', :locals => {:variant => :single_variant})
      subject.render_single_size
    end
  end

  describe '#render_multiple_sizes' do
    let(:sizes) { [:size_one, :size_two] }
    before :each do
      subject.product.stub_chain(:variants, :sorted_by_description).and_return(sizes)
    end
    it 'should render all variants to select' do
      template.should_receive(:render).with(:partial => 'product/sizes', :locals => {:variants => sizes})
      subject.render_multiple_sizes
    end
  end
  
  describe '#related_products' do
    context "when the product doesn't have any related products" do
      it "should return an empty array" do
        subject.related_products.should be_empty
      end
    end
    
    context "when the product has some related products " do
      let(:related_shoe)      { FactoryGirl.create(:basic_shoe) }
      let(:related_bag)       { FactoryGirl.create(:basic_bag) }
      let(:out_of_stock_bag)  { FactoryGirl.create(:basic_bag) }

      let!(:v_related_shoe)      { FactoryGirl.create(:basic_shoe_size_35, :product => related_shoe) }
      let!(:v_related_bag)       { FactoryGirl.create(:variant, :product => related_bag, :inventory => 10) }
      let!(:v_out_of_stock_bag)  { FactoryGirl.create(:variant, :product => out_of_stock_bag) }

      it "should return an empty array if all of them are of the same category as the presented product" do
        product.relate_with_product related_shoe
        subject.related_products.should == []
      end

      it "should only included products in stock" do
        product.relate_with_product out_of_stock_bag
        subject.related_products.should == []
      end

      it "should only the related products of a different category from the presented product" do
        product.relate_with_product related_shoe
        product.relate_with_product related_bag
        subject.related_products.should == [related_bag]
      end
    end
  end
end
