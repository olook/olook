require 'spec_helper'

describe Image do
  context "validation" do
    it { should validate_presence_of(:lookbook) }
    it { should belong_to(:lookbook) }
  end

  let!(:image) { FactoryGirl.create(:image) }

  it "should destroy the associated image when the product is destroyed" do
    expect {
      image.lookbook.destroy
    }.to change(Image, :count).by(-1)
  end

  it "should invalidate the image on Amazon Cloudfront" do
    pending "Please test me!"
    mock("CloudfrontInvalidator")
  end
end
