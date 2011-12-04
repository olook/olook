# -*- encoding : utf-8 -*-
require "spec_helper"

describe ShowroomPresenter do
  let(:member) { FactoryGirl.create :member }
  let(:template) { double :template }
  subject { described_class.new member, template }

  describe '#render_identification' do
    it "should render the partial with the FB avatar if the user is FB connected" do
      member.stub(:'has_facebook?').and_return(true)
      template.should_receive(:render).with(:partial => "showroom_facebook_connected", :locals => {:showroom_presenter => subject})
      subject.render_identification
    end
    it "should render the partial asking for the user to connect his account if he isn't FB connected" do
      member.stub(:'has_facebook?').and_return(false)
      template.should_receive(:render).with(:partial => "showroom_facebook_connect", :locals => {:showroom_presenter => subject})
      subject.render_identification
    end
  end
  
  describe '#collection_name' do
    it 'should return the current month name' do
      Date.stub_chain(:today, :month).and_return(4)
      subject.collection_name.should == 'Abril'
    end
  end
  
  describe '#display_products, should render the product partial for' do
    let(:fake_products) { Array.new(10, :one_product) }

    before :each do
      subject.member.stub(:all_profiles_showroom).with(Category::SHOE).and_return(fake_products)
    end

    it "a given range" do
      template.should_receive(:render).with(:partial => "shared/showroom_product_item", :locals => {:showroom_presenter => subject, :product => :one_product}).exactly(3).times.and_return('')
      template.should_receive(:raw).with('')
      subject.display_products (0..2), Category::SHOE
    end
    
    it "if it's not a range, return all remaining products staring at the index" do
      template.should_receive(:render).with(:partial => "shared/showroom_product_item", :locals => {:showroom_presenter => subject, :product => :one_product}).exactly(2).times.and_return('')
      template.should_receive(:raw).with('')
      subject.display_products 8, Category::SHOE
    end

    it "if the range doesn't exist, it should not call it the render" do
      subject.member.stub(:all_profiles_showroom).and_return([])
      template.should_not_receive(:render)
      template.should_receive(:raw).with('')
      subject.display_products 8, Category::SHOE
    end

    describe 'specific methods' do
      let(:range) { (1..10) }
      it "#display_shoes" do
        subject.should_receive(:display_products).with(range, Category::SHOE)
        subject.display_shoes(range)
      end
      it "#display_bags" do
        subject.should_receive(:display_products).with(range, Category::BAG)
        subject.display_bags(range)
      end
      it "#display_accessories" do
        subject.should_receive(:display_products).with(range, Category::ACCESSORY)
        subject.display_accessories(range)
      end
    end
  end

  describe '#product_picture' do
    let(:fake_product) { double :fake_product }
    it 'should return the product picture when it exists' do
      fake_product.stub(:showroom_picture).and_return('product_picture')
      template.should_receive(:image_tag).with('product_picture').and_return(:picture)
      subject.product_picture(fake_product).should == :picture
    end
    it "should return the default picture when it doesn't exist" do
      fake_product.stub(:showroom_picture).and_return(nil)
      template.should_receive(:image_tag).with("fake/showroom-product.png").and_return(:default_picture)
      subject.product_picture(fake_product).should == :default_picture
    end
  end
  
  describe '#parse_range' do
    let(:array) { Array.new(10, :item) }
    it "should return the asked range if it's withing limits" do
      subject.send(:parse_range, (1..3), array).should == (1..3)
    end
    it "should return the asked range limited to the array boundaries" do
      subject.send(:parse_range, (1..13), array).should == (1..9)
    end
    it "should return a range starting at the index up to the array boundaries" do
      subject.send(:parse_range, 5, array).should == (5..9)
    end
  end
  
  describe '#welcome_message' do
    before :each do
      subject.member.stub(:first_name).and_return('Fulana')
    end

    it "should return 'Bom dia, fulana' if it's day" do
      subject.welcome_message(10).should == 'Bom dia, Fulana!'
    end
    it "should return 'Boa tarde, fulana' if it's day" do
      subject.welcome_message(12).should == 'Boa tarde, Fulana!'
    end
    it "should return 'Boa noite, fulana' if it's night" do
      subject.welcome_message(19).should == 'Boa noite, Fulana!'
    end
  end
  
  describe '#facebook_avatar' do
    it "should return the FB avatar, size normal, which should have 100px width" do
      subject.member.stub(:uid).and_return('fake_uid')
      template.should_receive(:image_tag).with("https://graph.facebook.com/fake_uid/picture?type=large", :class => 'avatar').and_return('fb_avatar')
      subject.facebook_avatar.should == 'fb_avatar'
    end
  end
end
