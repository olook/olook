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
    context "Catalog" do
      before do
        @search = SearchEngine.new(category: 'sapato')
        @seo_class = Seo::SeoManager.new("/sapato", search: @search)
      end
      it "return categories on seo text" do
        expect(@seo_class.select_meta_tag).to eql('Sapatos Femininos | Olook')
      end
      context "When have 2 subcategories" do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira-sapatilha')
          @seo_class = Seo::SeoManager.new("/sapato", search: @search)
        end
        it "return categories with different text" do
          expect(@seo_class.select_meta_tag).to eql('Rasteira - Sapatilha | Olook')
        end
      end
      context "When have 4 subcategories" do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira-sapatilha-boneca-anabela')
          @seo_class = Seo::SeoManager.new("/sapato", search: @search)
        end
        it "return categories with different text" do
          expect(@seo_class.select_meta_tag).to eql('Rasteira - Sapatilha - Boneca e outros | Olook')
        end
      end
      context "When have color and category" do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira', color: 'dourado')
          @seo_class = Seo::SeoManager.new("/sapato", search: @search)
        end
        it "return categories with different text" do
          expect(@seo_class.select_meta_tag).to eql('Rasteira Dourado | Olook')
        end
      end
      context "When have one color" do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira-sapatilha', color: 'azul')
          @seo_class = Seo::SeoManager.new("/sapato", search: @search)
        end
        it "return color on result" do
          expect(@seo_class.select_meta_tag).to eql('Rasteira - Sapatilha Azul | Olook')
        end
      end
      context "When have two color" do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira-sapatilha', color: 'azul-dourado')
          @seo_class = Seo::SeoManager.new("/sapato", search: @search)
        end
        it "return color on result" do
          expect(@seo_class.select_meta_tag).to eql('Rasteira - Sapatilha Azul Dourado | Olook')
        end
      end
      context "When have size " do
        before do
          @search = SearchEngine.new(category: 'sapato', subcategory: 'rasteira-sapatilha', size: '34')
          @seo_class = Seo::SeoManager.new("/sapato/Rasteira/tamanho-33", search: @search)
        end

        it "returns 'Rasteira | Olook' without size " do
          expect(@seo_class.select_meta_tag).to eql('Rasteira - Sapatilha | Olook')
        end
      end
      context "and the category is 'acessorio' " do
        before do
          @search = SearchEngine.new(category: 'acessorio', color: "dourado")
          @seo_class = Seo::SeoManager.new("/acessorio/cor-dourado", search: @search)
        end

        it "returns acessory text" do
          expect(@seo_class.select_meta_tag).to eql('Bijuterias - Semi Joia e Bijuterias Finas Dourado | Olook')
        end
      end
      context "and the category is 'roupa' " do
        before do
          @search = SearchEngine.new(category: 'roupa', color: "dourado")
          @seo_class = Seo::SeoManager.new("/roupa/cor-dourado", search: @search)
        end

        it "returns cloth text" do
          expect(@seo_class.select_meta_tag).to eql('Roupas Femininas Dourado | Olook')
        end
      end
      context "and the category is 'bolsa' " do
        before do
          @search = SearchEngine.new(category: 'bolsa', color: "dourado")
          @seo_class = Seo::SeoManager.new("/bolsa/cor-dourado", search: @search)
        end

        it "returns bag text" do
          expect(@seo_class.select_meta_tag).to eql('Bolsas Femininas Dourado | Olook')
        end
      end
    end

    context "When have model" do
      context "product with big name" do
        before do
          @product = FactoryGirl.build(:shoe, name: 'Vestido Estampado Manga Longa Ecletic')
          @seo_model = Seo::SeoManager.new("/asd", model: @product)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to match('Vestido Estampado Manga Longa Ecletic Black | Olook')
        end
      end
      context "product with small name" do
        before do
          @product = FactoryGirl.build(:shoe, name: 'Vestido Estampado')
          @seo_model = Seo::SeoManager.new("/asd", model: @product)
        end
        it "return specific meta tag" do
          expect(@seo_model.select_meta_tag).to match('Vestido Estampado - Roupas e Sapatos Femininos | Olook')
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
        context "with color" do
          before do
            @search = SearchEngine.new( color: "dourado")
            @collection_theme = FactoryGirl.build(:collection_theme)
            @seo_model = Seo::SeoManager.new("/asd", model: @collection_theme, search: @search)
          end
          it "return specific meta tag" do
            expect(@seo_model.select_meta_tag).to eql('dia-a-dia - Saias Longas e Camisetas Dourado | Olook')
          end
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
        context "with color" do
          before do
            @search = SearchEngine.new( color: "dourado")
            @brand = FactoryGirl.build(:brand)
            @seo_model = Seo::SeoManager.new("/asd", model: @brand, search: @search)
          end
          it "return specific meta tag with color" do
            expect(@seo_model.select_meta_tag).to eql('Colcci - Calcas e vestidos Dourado | Olook')
          end
        end
      end
      context "When the url is '/marcas/Mandi' and dont have title tag" do
        before do
          @brand = FactoryGirl.build(:brand, name: 'mandi', seo_text: nil)
          @seo_class = Seo::SeoManager.new("/marcas/Mandi", model: @brand)
        end

        it "returns 'Mandi | Olook' " do
          expect(@seo_class.select_meta_tag).to eql('Mandi | Olook')
        end
      end
    end
    context "When dont receive search or model" do
      before do
        @seo_class = Seo::SeoManager.new("/termos")
      end

      it "looks seo text on file" do
        expect(@seo_class.select_meta_tag).to eql('Termos de Uso | Olook')
      end
    end
  end
end
