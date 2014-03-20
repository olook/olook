# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:all_categories).and_return({ "Sapato" => [], "Roupa" => [], "Acessório" => [], "Bolsa" => [] })
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota", "Camiseta"])
    described_class.stub(:db_brands).and_return(["Colcci","Olook"])
  end

  describe "#parse_params" do
    it { expect(described_class.new.parse_params).to be_a(Hash)  }
    context "Main keys" do
      context "that include collection themes" do
        subject { described_class.new(path: '/colecoes/p&b') }
        it { expect(subject.parse_params).to have_key(:collection_theme)  }
        it { expect(subject.parse_params[:collection_theme]).to eq('p&b') }
      end
      context "that includes brands" do
        subject { described_class.new(path: '/marcas/olook') }
        it { expect(subject.parse_params).to have_key(:brand)  }
        it { expect(subject.parse_params[:brand]).to eq('Olook') }
      end
      context "that includes brands" do
        subject { described_class.new(path: '/sapato') }
        it { expect(subject.parse_params).to have_key(:category)  }
        it { expect(subject.parse_params[:category]).to eq('sapato') }
      end
    end
    context "Main keys and filters" do
      context "that includes brands as main category as filter" do
        subject { described_class.new(path: '/sapato/olook') }
        it { expect(subject.parse_params[:brand]).to eq('Olook') }
        it { expect(subject.parse_params[:category]).to eq('sapato') }
      end
      context "that includes category as main" do
        context "brands as filter" do
          context "one brand" do
            subject { described_class.new(path: '/sapato/olook') }
            it { expect(subject.parse_params[:category]).to eq('sapato') }
            it { expect(subject.parse_params[:brand]).to eq('Olook') }
          end
          context "multiple brands" do
            subject { described_class.new(path: '/sapato/olook-colcci') }
            it { expect(subject.parse_params[:category]).to eq('sapato') }
            it { expect(subject.parse_params[:brand]).to match(/Olook/i) }
            it { expect(subject.parse_params[:brand]).to match(/Colcci/i) }
          end
        end
        context "and filtering by care products" do
          subject { described_class.new(path: '/sapato/conforto-amaciante-palmilha') }
          it { expect(subject.parse_params[:category]).to eq('sapato') }
          it { expect(subject.parse_params[:care]).to eq('amaciante-palmilha') }
        end
      end
      context "filtering by subcategory" do
        context "one subcategory" do
          subject { described_class.new(path: '/sapato/bota') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
        end
        context "multiple subcategories" do
          subject { described_class.new(path: '/sapato/bota-scarpin') }
          it { expect(subject.parse_params[:category]).to eq('sapato') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota-scarpin') }
        end
      end
      context "filtering by colors and size" do
        context "one color" do
          subject { described_class.new(path: '/sapato/bota/cor-azul') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul') }
        end
        context "one size" do
          subject { described_class.new(path: '/sapato/bota/tamanho-37') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:size]).to eq('37') }
        end
        context "multiple colors" do
          subject { described_class.new(path: '/sapato/bota/cor-azul-amarelo') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul-amarelo') }
        end
        context "multiple sizes" do
          subject { described_class.new(path: '/sapato/bota/tamanho-37-40') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:size]).to eq('37-40') }
        end
        context "colors and sizes" do
          subject { described_class.new(path: '/sapato/bota/cor-azul_tamanho-37') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul') }
          it { expect(subject.parse_params[:size]).to eq('37') }
        end
      end
    end

    context "filtering by ordenation" do
      context "lower price" do
        subject { described_class.new(path: '/sapato?por=menor-preco') }
        it { expect(subject.parse_params[:sort]).to eq('retail_price') }
      end

      context "greater price" do
        subject { described_class.new(path: '/sapato?por=maior-preco') }
        it { expect(subject.parse_params[:sort]).to eq('-retail_price') }
      end

      context "lower discount" do
        subject { described_class.new(path: '/sapato?por=maior-desconto') }
        it { expect(subject.parse_params[:sort]).to eq('-desconto') }
      end
    end

    context "ordering by price range" do
      subject { described_class.new(path: '/sapato?preco=100-300') }
      it { expect(subject.parse_params[:price]).to eq('100-300') }
    end

    context "with custom path_positions" do
      subject { described_class.new(path: '/marcas/olook/sapato', path_positions: '/marcas/:brand:/:category:-:subcategory/:color:-:size:-:heel:') }
      it { expect(subject.parse_params[:brand]).to eq('olook') }
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
        ).to eq('blusa-jaqueta')
      end

      it "should use the link_builder" do
        search_engine.stub(:filters_applied).and_return({subcategory: ['blusa']})
        subject.set_link_builder do |path|
          "TESTE#{path}"
        end
        expect(subject.add_filter(:subcategory, 'blusa')).to eq('TESTEblusa')
      end
    end
  end
end

