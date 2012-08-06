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
    cloud_instance = double(CloudfrontInvalidator)
    picture.stub_chain(:image, :url => "http://testcdn.olook.com.br/xpto/image-db69d8f1477df37df02d80646087fed28f7fe0f1f7a2d82694ed073b76071379.jpg")
    cloud_instance.should_receive(:invalidate).with(picture.image.url.slice(23..150))
    CloudfrontInvalidator.should_receive(:new).and_return(cloud_instance)
    picture.send(:invalidate_cdn_image)
  end
end
