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
    cloud_instance = double(CloudfrontInvalidator)
    image.stub_chain(:image, :url => "http://testcdn.olook.com.br/xpto/image-db69d8f1477df37df02d80646087fed28f7fe0f1f7a2d82694ed073b76071379.jpg")
    cloud_instance.should_receive(:invalidate).with(image.image.url.slice(23..150))
    CloudfrontInvalidator.should_receive(:new).and_return(cloud_instance)
    image.send(:invalidate_cdn_image)
  end
end
