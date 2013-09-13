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

  describe "#meta_tag" do
    it "always return value" do
      expect(@seo_class.select_meta_tag).to_not be_nil
    end
    context "When dont match url dont match to file items " do
      it "return default" do
        seo_class_fail = Seo::SeoManager.new("/asd")
        expect(seo_class_fail.select_meta_tag).to eql('Sapatos Femininos e Roupas Femininas | Olook')
      end
    end
    context "When find meta tags on file" do
      it "return map meta tag" do
        expect(@seo_class.select_meta_tag).to eql('Sapatos Femininos | Olook')
      end
    end
    context "When find meta tags on model" do
      before do
        @product = FactoryGirl.create(:shoe, name: 'Vestido Estampado Manga Longa Ecletic')
        @seo_model = Seo::SeoManager.new("/asd", model: @product)
      end
      it "return map meta tag" do
        expect(@seo_class.select_meta_tag).to eql('Vestido Estampado Manga Longa Ecletic - Roupas e Sapatos Femininos | Olook')
      end
    end
  end
end
