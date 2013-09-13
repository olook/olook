require 'spec_helper'

describe Seo::SeoManager do
  before do
    @seo_class = Seo::SeoManager.new("/sapato")
  end
  describe "#initialize" do
    it "set url" do
      expect(@seo_class.url).to_not be_nil
    end
  end

  context "When find on meta tags constant file" do
    describe "#meta_tag" do
      it "always return value" do
        expect(@seo_class.meta_tag).to_not be_nil
      end

      it "return map meta tag" do
      end
    end
  end
end
