# -*- encoding : utf-8 -*-
require "spec_helper"

describe LookbookPictureUploader do
  include CarrierWave::Test::Matchers

  before :all do
    described_class.enable_processing = true
  end

  after :all do
    described_class.enable_processing = false
  end

  let(:valid_image)     { File.join fixture_path, 'valid_image.jpg' }
  let(:invalid_image)   { File.join fixture_path, 'invalid_image.txt' }
  let(:basic_lookbook)  { FactoryGirl.create :basic_lookbook }

  subject { described_class.new(basic_lookbook, :basic_lookbook) }

  describe "an uploaded image" do
    before :all do
      subject.store!(File.open(valid_image))
    end

    it "should exist" do
     subject.path.should be_true
    end

    it "responds to movie_thumb size" do
      subject.movie_thumb.path.should be_true
    end

    it "responds to movie_thumb_mini size" do
      subject.movie_thumb_mini.path.should be_true
    end
  end

end