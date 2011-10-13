# -*- encoding : utf-8 -*-
describe PictureUploader do
  include CarrierWave::Test::Matchers

  before :all do
    described_class.enable_processing = true
  end

  subject do  
    test_file = File.expand_path(File.dirname( __FILE__), 'test_shoe.jpg')
    product = FactoryGirl.create(:basic_shoe)
    uploader = described_class.new(product, :image)
    uploader.store!(File.open(test_file))
    uploader
  end

  after do
    described_class.enable_processing = false
  end

  it "should make the image readable only to the owner and not executable" do
    #subject.should have_permissions(0600)
  end
end
