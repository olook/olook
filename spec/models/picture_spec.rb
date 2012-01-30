# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Picture do
  context "validation" do
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }
  end

  let!(:picture) { FactoryGirl.create(:main_picture) }

  it "should destroy the associated picture when the product is destroyed" do
    expect {
      picture.product.destroy
    }.to change(Picture, :count).by(-1)
  end

  it "should invalidate the image on Amazon Cloudfront" do
    pending "Please test me!"
    mock("CloudfrontInvalidator")
  end
end
