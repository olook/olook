require 'spec_helper'

describe Seo::SeoManager do
  before do
    @seo_class = Seo::SeoManager.new("/sapato")
    @header = FactoryGirl.create(:header, :no_banner, url: "/sapato", title: "Sapatos Femininos")
  end
  describe "#initialize" do
    it "set url" do
      expect(@seo_class.url).to_not be_nil
    end
  end

  describe "#select_meta_tag" do
    it "always return value" do
      expect(@seo_class.select_meta_tag).to_not be_nil
    end
    context "When dont match url to file items" do
      before do
        @seo_class_fail = Seo::SeoManager.new("/asd")
      end
      it "return default page title" do
        expect(@seo_class_fail.select_meta_tag[:title]).to eql("#{Seo::SeoManager::DEFAULT_PAGE_TITLE} | Olook")
      end
      it "return default page descritpion" do
        expect(@seo_class_fail.select_meta_tag[:description]).to eql(Seo::SeoManager::DEFAULT_PAGE_DESCRIPTION)
      end
    end
    context "When on subcategory but dont have header" do
      before do
        @seo_class = Seo::SeoManager.new("/sapato/apargata")
      end
      it "return previous page title" do
        expect(@seo_class.select_meta_tag[:title]).to eql("#{@header.page_title} | Olook")
      end
    end
    context "When have subcategory" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", title: "Alpargatas Femininos")
        @seo_class = Seo::SeoManager.new("/sapato/apargata")
      end
      it "return previous page title" do
        expect(@seo_class.select_meta_tag[:title]).to eql("#{@header.page_title} | Olook")
      end
    end
    context "When have tree sub level on url and dont have subcategory" do
      before do
        @seo_class = Seo::SeoManager.new("/sapato/apargata/low")
      end
      it "return previous page title" do
        expect(@seo_class.select_meta_tag[:title]).to eql("#{@header.page_title} | Olook")
      end
    end
  end
end
