# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:all_categories).and_return({ "Sapato" => [], "Roupa" => [], "Acessório" => [], "Bolsa" => [] })
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota", "Camiseta"])
    described_class.stub(:db_brands).and_return(["Colcci","Olook"])
  end

  describe "#parse_params" do
    context "Main keys" do
      context "that include collection themes" do
        subject { described_class.new(path: '/colecoes/p&b', path_positions: '/colecoes/:collection_theme:') }
        it { expect(subject.parse_params).to have_key(:collection_theme)  }
        it { expect(subject.parse_params[:collection_theme]).to match(/p&b/i) }
      end
      context "that includes brands" do
        subject { described_class.new(path: '/marcas/olook', path_positions: '/marcas/:brand:') }
        it { expect(subject.parse_params).to have_key(:brand)  }
        it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
      end
      context "that includes category" do
        subject { described_class.new(path: '/sapato', path_positions: '/:category:/:brand:-:subcategory:/:color:-:size:-:heel:') }
        it { expect(subject.parse_params).to have_key(:category)  }
        it { expect(subject.parse_params[:category]).to match(/Sapato/i) }
      end
    end
    context "Main keys and filters" do
      context "that includes brands as main category as filter" do
        subject { described_class.new(path: '/sapato/olook', path_positions: '/:category:/:brand:-:subcategory:/:color:-:size:-:heel:') }
        it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
        it { expect(subject.parse_params[:category]).to match(/Sapato/i) }
      end
      context "that includes category as main" do
        context "brands as filter" do
          context "one brand" do
            subject { described_class.new(path: '/sapato/olook', path_positions: '/:category:/:brand:-:subcategory:/:color:-:size:-:heel:') }
            it { expect(subject.parse_params[:category]).to match(/Sapato/i) }
            it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
          end
          context "multiple brands" do
            subject { described_class.new(path: '/sapato/olook-colcci', path_positions: '/:category:/:brand:-:subcategory:/:color:-:size:-:heel:') }
            it { expect(subject.parse_params[:category]).to match(/Sapato/i) }
            it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
            it { expect(subject.parse_params[:brand]).to match(/Colcci/i) }
          end
        end
        context "and filtering by care products" do
          subject { described_class.new(path: '/sapato/conforto-amaciante-palmilha', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:category]).to match(/Sapato/i) }
          it { expect(subject.parse_params[:care]).to match(/amaciante-palmilha/i) }
        end
      end
      context "filtering by subcategory" do
        context "one subcategory" do
          subject { described_class.new(path: '/sapato/bota', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
        end
        context "multiple subcategories" do
          subject { described_class.new(path: '/sapato/bota-scarpin', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:category]).to match(/sapato/i) }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:subcategory]).to match(/scarpin/i) }
        end
      end
      context "filtering by colors and size" do
        context "one color" do
          subject { described_class.new(path: '/sapato/bota/cor-azul', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:color]).to match(/azul/i) }
        end
        context "one size" do
          subject { described_class.new(path: '/sapato/bota/tamanho-37', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:size]).to match(/37/i) }
        end
        context "multiple colors" do
          subject { described_class.new(path: '/sapato/bota/cor-azul-amarelo', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:color]).to match(/azul-amarelo/i) }
        end
        context "multiple sizes" do
          subject { described_class.new(path: '/sapato/bota/tamanho-37-40', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:size]).to match(/37-40/i) }
        end
        context "colors and sizes" do
          subject { described_class.new(path: '/sapato/bota/cor-azul_tamanho-37', path_positions: '/:category:/:brand:-:subcategory:/:care:-:color:-:size:-:heel:') }
          it { expect(subject.parse_params[:subcategory]).to match(/bota/i) }
          it { expect(subject.parse_params[:color]).to match(/azul/i) }
          it { expect(subject.parse_params[:size]).to match(/37/i) }
        end
      end
    end

    context "filtering by ordenation" do
      context "lower price" do
        subject { described_class.new(path: '/sapato?por=menor-preco') }
        it { expect(subject.parse_params[:sort]).to match(/retail_price/i) }
      end

      context "greater price" do
        subject { described_class.new(path: '/sapato?por=maior-preco') }
        it { expect(subject.parse_params[:sort]).to match(/-retail_price/i) }
      end

      context "lower discount" do
        subject { described_class.new(path: '/sapato?por=maior-desconto') }
        it { expect(subject.parse_params[:sort]).to match(/-desconto/i) }
      end
    end

    context "ordering by price range" do
      subject { described_class.new(path: '/sapato?preco=100-300') }
      it { expect(subject.parse_params[:price]).to match(/100-300/i) }
    end

    context "with custom path_positions" do
      subject { described_class.new(path: '/marcas/olook/sapato', path_positions: '/marcas/:brand:/:category:-:subcategory/:color:-:size:-:heel:') }
      it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
    end
  end

  describe '#add_filter' do
    let(:search_engine) { double 'SearchEngine' }
    context "using default initialization" do
      subject { described_class.new(search: search_engine) }
      before do
        search_engine.stub(:filters_applied).and_return({})
      end

      it "@search stores the actual filters using #filters_applied" do
        subject.add_filter(:subcategory, "blusa")
      end

      it "delegate calculation of adding filters to @search" do
        search_engine.should_receive(:filters_applied).with(:subcategory, 'blusa')
        subject.add_filter(:subcategory, 'blusa')
      end

      it "should permit manipulate the filters after search with a block" do
        search_engine.stub(:filters_applied).and_return({subcategory: ['blusa']})
        expect(
          subject.add_filter(:subcategory, 'blusa') { |filters|
            filters[:subcategory].push('jaqueta')
            filters
          }
        ).to match(/blusa-jaqueta/i)
      end

      it "should use the link_builder" do
        search_engine.stub(:filters_applied).and_return({subcategory: ['blusa']})
        subject.set_link_builder do |path|
          "TESTE#{path}"
        end
        expect(subject.add_filter(:subcategory, 'blusa')).to match(/TESTEblusa/i)
      end
    end
  end
end

