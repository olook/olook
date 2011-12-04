# -*- encoding : utf-8 -*-
require "spec_helper"

describe PictureUploader do
  include CarrierWave::Test::Matchers

  before :all do
    described_class.enable_processing = true
  end

  after :all do
    described_class.enable_processing = false
  end

  let(:test_file_dir) { File.expand_path File.dirname( __FILE__) }
  let(:valid_image)   { File.join test_file_dir, 'valid_image.jpg' }
  let(:invalid_image) { File.join test_file_dir, 'invalid_image.txt' }
  let(:picture)       { FactoryGirl.create :main_picture }

  subject { described_class.new(picture, :image) }

  describe "an uploaded image" do
    before :each do
      subject.store!(File.open(valid_image))
    end

    it "should exist" do
     subject.path.should be_true
    end

    describe 'should have different sizes' do
      it "thumb size" do
        subject.thumb.path.should be_true
      end
      it "main size" do
        subject.main.path.should be_true
      end
      it "showroom size" do
        subject.showroom.path.should be_true
      end
      it "suggestion size" do
        subject.suggestion.path.should be_true
      end
      it "bag size" do
        subject.bag.path.should be_true
      end
      it "zoom_out size" do
        subject.zoom_out.path.should be_true
      end
    end
  end

  it "should only allow the uploading of image files" do
    expect {
      subject.store!(File.open(invalid_image))
    }.to raise_error(CarrierWave::IntegrityError)
  end
  
  it 'should store images on directories with the product model name' do
    subject.stub_chain(:model, :class, :name, :underscore, :pluralize).and_return('dir')
    subject.stub_chain(:model, :product, :model_number).and_return('product')
    subject.stub_chain(:model, :display_on).and_return('display')
    subject.store_dir.should == "dir/product/display"
  end
end
