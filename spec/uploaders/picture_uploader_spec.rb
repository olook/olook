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
  let(:picture)       { FactoryGirl.create :gallery_picture }

  subject { described_class.new(picture, :image) }

  describe "an uploaded image" do
    before :each do
      subject.store!(File.open(valid_image))
    end

    it "should exist" do
     subject.path.should be_true
    end

    it "should have a thumb version" do
      subject.thumb.path.should be_true
    end
  end
  
  it "should only allow the uploading of image files" do
    expect {
      subject.store!(File.open(invalid_image))
    }.to raise_error(CarrierWave::IntegrityError)
  end
end
