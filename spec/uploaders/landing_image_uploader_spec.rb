# -*- encoding : utf-8 -*-
require "spec_helper"

describe LandingImageUploader do
  include CarrierWave::Test::Matchers

  before :all do
    described_class.enable_processing = true
  end

  after :all do
    described_class.enable_processing = false
  end

  let(:valid_image)   { File.join fixture_path, 'valid_image.jpg' }
  let(:invalid_image) { File.join fixture_path, 'invalid_image.txt' }
  let(:landing)       { FactoryGirl.create :landing_page }

  subject { described_class.new(landing, :landing) }

  describe "an uploaded image" do
    before :all do
      subject.store!(File.open(valid_image))
    end

    it "should exist" do
     subject.path.should be_true
    end

    it "responds to thumb size" do
      subject.thumb.path.should be_true
    end
  end
end