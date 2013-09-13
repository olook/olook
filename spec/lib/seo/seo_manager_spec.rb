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

end
