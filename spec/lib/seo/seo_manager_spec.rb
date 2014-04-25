require 'spec_helper'

describe Seo::SeoManager do
  before do
    @seo_class = Seo::SeoManager.new("/sapato")
    @header = FactoryGirl.create(:header, :no_banner, url: "/sapato", page_title: "Sapatos Femininos")
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
        @header_sub = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", page_title: "Alpargatas Femininos")
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
    context "When brand have space" do
      before do
        @seo_class = Seo::SeoManager.new("/marcas/Douglas Harris")
        @header = FactoryGirl.create(:header, :no_banner, url: "/marcas/douglas-harris", page_title: "Douglas Harris")
      end
      it "return previous page title" do
        expect(@seo_class.select_meta_tag[:title]).to eql("#{@header.page_title} | Olook")
      end
    end
    context "When have product" do
      before do
        @product = FactoryGirl.build(:product, description: "product description")
        @seo_class = Seo::SeoManager.new("/#{@product.seo_path}", fallback_title: "O Produto",fallback_description: @product.seo_description)
      end
      it "return product title" do
        @product.should_receive(:title_text).and_return("O Produto")
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@product.title_text} | Olook")
      end
      it "return product description" do
        expect(@seo_class.select_meta_tag[:description]).to eql (@product.seo_description )
      end
    end
    context "When have color" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", page_title: "Alpargatas Femininos")
        @seo_class = Seo::SeoManager.new("/sapato/alpargata/cor-azul", color: "Azul")
      end
      it "return product title" do
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@header.page_title} Azul | Olook")
      end
    end
    context "When have size" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", page_title: "Alpargatas Femininos")
        @seo_class = Seo::SeoManager.new("/sapato/alpargata/tamanho-GG", size: "GG")
      end
      it "return product title" do
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@header.page_title} Tamanho Gg | Olook")
      end
    end
    context "When have size and color" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", page_title: "Alpargatas Femininos")
        @seo_class = Seo::SeoManager.new("/sapato/alpargata/tamanho-GG", size: "GG", color: "Azul")
      end
      it "return product title" do
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@header.page_title} Azul Tamanho Gg | Olook")
      end
    end
    context "When there is empty color" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/sapato/alpargata", page_title: "Alpargatas Femininos")
        @seo_class = Seo::SeoManager.new("/sapato/alpargata/tamanho-GG", color: " ")
      end
      it "return product title" do
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@header.page_title} | Olook")
      end
    end
    context "When there is some subcategory and brand" do
      before do
        @header = FactoryGirl.create(:header, :no_banner, url: "/bolsa/clutch", page_title: "Clutch Femininas")
        @seo_class = Seo::SeoManager.new("/bolsa/clutch-colcci", brand: "Colcci")
      end
      it "return subcategory with brand" do
        expect(@seo_class.select_meta_tag[:title]).to eql ("#{@header.page_title} Colcci | Olook")
      end
    end
  end
end
