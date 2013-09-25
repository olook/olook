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

  describe "#select_meta_tag" do
    it "always return value" do
      expect(@seo_class.select_meta_tag).to_not be_nil
    end
    context "When dont match url to file items " do
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

    context "When there is one color on url" do
      before do
        @seo_class = Seo::SeoManager.new("/sapato/cor-dourado")
      end

      it "returns map meta tag with the color" do
        expect(@seo_class.select_meta_tag).to eql('Sapatos Dourado | Olook')
      end
    end

    context "When there are multiple colors on url" do
      before do
        @seo_class = Seo::SeoManager.new("/sapato/cor-dourado-azul")
      end
      it "returns standard map meta tag without colors" do
        expect(@seo_class.select_meta_tag).to eql('Sapatos Femininos | Olook')
      end

    end

    context "When the url is '/marcas/Mandi' " do
      before do
        brand_mock = OpenStruct.new({title_text: 'Mandi - Blusas, Saias de Festa e Camisas | Olook'})
        @seo_class = Seo::SeoManager.new("/marcas/Mandi", {model: brand_mock})
      end

      it "returns 'Mandi - Blusas, Saias de Festa e Camisas | Olook' " do
        expect(@seo_class.select_meta_tag).to eql('Mandi - Blusas, Saias de Festa e Camisas | Olook')
      end
    end

    context "When the url is '/sapato/Rasteira' " do
      before do
        model_mock = OpenStruct.new({title_text: 'Rasteira | Olook'})
        @seo_class = Seo::SeoManager.new("/sapato/Rasteira", {model: model_mock})
      end

      it "returns 'Rasteira | Olook' " do
        expect(@seo_class.select_meta_tag).to eql('Rasteira | Olook')
      end
    end


    context "When have model" do
      context "product with big name" do
        before do
          @product = FactoryGirl.build(:shoe, name: 'Vestido Estampado Manga Longa Ecletic')
          @seo_model = Seo::SeoManager.new("/asd", model: @product)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to eql('Vestido Estampado Manga Longa Ecletic Black | Olook')
        end
      end
      context "product with small name" do
        before do
          @product = FactoryGirl.build(:shoe, name: 'Vestido Estampado')
          @seo_model = Seo::SeoManager.new("/asd", model: @product)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to eql('Vestido Estampado Black - Roupas e Sapatos Femininos | Olook')
        end
      end
      context "collection theme" do
        before do
          @collection_theme = FactoryGirl.build(:collection_theme)
          @seo_model = Seo::SeoManager.new("/asd", model: @collection_theme)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to eql('dia-a-dia - Saias Longas e Camisetas | Olook')
        end
      end
      context "brand" do
        before do
          @brand = FactoryGirl.build(:brand)
          @seo_model = Seo::SeoManager.new("/asd", model: @brand)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to eql('Colcci - Calcas e vestidos | Olook')
        end
      end
    end
  end
end
