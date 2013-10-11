# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:all_categories).and_return({ "Sapato" => [], "Roupa" => [], "Acessório" => [], "Bolsa" => [] })
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota", "Camiseta"])
    described_class.stub(:db_brands).and_return(["Colcci","Olook"])
  end

  describe "#parse_params" do
    it { expect(described_class.new({}).parse_params).to be_a(Hash)  }
    context "Main keys" do
      context "that include collection themes" do
        subject { described_class.new('/colecoes/p&b') }
        it { expect(subject.parse_params).to have_key(:collection_theme)  }
        it { expect(subject.parse_params[:collection_theme]).to eq('p&b') }
      end
      context "that includes brands" do
        subject { described_class.new('/marcas/olook') }
        it { expect(subject.parse_params).to have_key(:brand)  }
        it { expect(subject.parse_params[:brand]).to eq('olook') }
      end
      context "that includes brands" do
        subject { described_class.new('/sapato') }
        it { expect(subject.parse_params).to have_key(:category)  }
        it { expect(subject.parse_params[:category]).to eq('sapato') }
      end
    end
    context "Main keys and filters" do
      context "that includes brands as main category as filter" do
        subject { described_class.new('/sapato/olook') }
        it { expect(subject.parse_params[:brand]).to eq('olook') }
        it { expect(subject.parse_params[:category]).to eq('sapato') }
      end
      context "that includes category as main" do
        context "brands as filter" do
          context "one brand" do
            subject { described_class.new('/sapato/olook') }
            it { expect(subject.parse_params[:category]).to eq('sapato') }
            it { expect(subject.parse_params[:brand]).to eq('olook') }
          end
          context "multiple brands" do
            subject { described_class.new('/sapato/olook-colcci') }
            it { expect(subject.parse_params[:category]).to eq('sapato') }
            it { expect(subject.parse_params[:brand]).to eq('Olook-Colcci') }
          end
        end
        context "and filtering by care products" do
          subject { described_class.new('/sapato/conforto-amaciante-palmilha') }
          it { expect(subject.parse_params[:category]).to eq('sapato') }
          it { expect(subject.parse_params[:care]).to eq('amaciante-palmilha') }
        end
      end
      context "filtering by subcategory" do
        context "one subcategory" do
          subject { described_class.new('/sapato/bota') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
        end
        context "multiple subcategories" do
          subject { described_class.new('/sapato/bota-scarpin') }
          it { expect(subject.parse_params[:category]).to eq('sapato') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota-scarpin') }
        end
      end
      context "filtering by colors and size" do
        context "one color" do
          subject { described_class.new('/sapato/bota/cor-azul') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul') }
        end
        context "one size" do
          subject { described_class.new('/sapato/bota/tamanho-37') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:size]).to eq('37') }
        end
        context "multiple colors" do
          subject { described_class.new('/sapato/bota/cor-azul-amarelo') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul-amarelo') }
        end
        context "multiple sizes" do
          subject { described_class.new('/sapato/bota/tamanho-37-40') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:size]).to eq('37-40') }
        end
        context "colors and sizes" do
          subject { described_class.new('/sapato/bota/cor-azul_tamanho-37') }
          it { expect(subject.parse_params[:subcategory]).to eq('bota') }
          it { expect(subject.parse_params[:color]).to eq('azul') }
          it { expect(subject.parse_params[:size]).to eq('37') }
        end
      end
    end

    context "filtering by ordenation" do
      context "lower price" do
        subject { described_class.new('/sapato/menor-preco') }
        it { expect(subject.parse_params[:sort]).to eq('retail_price') }
      end

      context "greater price" do
        subject { described_class.new('/sapato/maior-preco') }
        it { expect(subject.parse_params[:sort]).to eq('-retail_price') }
      end

      context "lower discount" do
        subject { described_class.new('/sapato/maior-desconto') }
        it { expect(subject.parse_params[:sort]).to eq('-desconto') }
      end
    end

    context "ordering by price range" do
      subject { described_class.new('/sapato?preco=100-300') }
      it { expect(subject.parse_params[:price]).to eq('100-300') }
    end
  end


  describe 'add_filter' do
    let(:search_engine) { SearchEngine.new({ }) }
    subject { described_class.new({ }, "category", search_engine) }
    context "when given params has subcategory" do

      it "@search receives SearchEngine#filters_applied" do
        search_engine.should_receive(:filters_applied).and_return({"category"=>["roupa"], "subcategory"=>["blusa"]})
        subject.add_filter(:subject, "blusa")
      end

      it { expect(subject.add_filter(:subcategory, 'blusa')).to eq({ parameters: 'blusa' }) }

      context "and filters and care products" do
        before do
          search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Bota'], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']})
        end
        it { expect(subject.add_filter(:subcategory, 'blusa')).to eq(parameters: "bota/conforto-amaciante_tamanho-36-p_cor-azul-vermelho") }
      end

      context "and only filters" do
        before do
          search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Bota'], size: ['36', 'p'], color: ['azul', 'vermelho']})
        end
        it { expect(subject.add_filter(:subcategory, 'blusa')).to eq(parameters: "bota/tamanho-36-p_cor-azul-vermelho") }
      end

      context "and only care products" do
        before do
          search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Bota'], care: ['amaciante']})
        end
        it { expect(subject.add_filter(:subcategory, 'blusa')).to eq(parameters: "bota/conforto-amaciante") }
      end

      context "and brand together" do
        before do
          search_engine.stub(:filters_applied).and_return({ category: [ 'roupa' ], subcategory: ['bota'], brand: ['colcci', 'olook'], care:['amaciante']})
        end
        it { expect(subject.add_filter(:subcategory, 'blusa')).to eq(parameters: "colcci-olook-bota/conforto-amaciante") }
      end
    end

    context "when given params has no subcategories but has filters" do
      before do
        search_engine.stub(:filters_applied).and_return({ category: ['sapato'], size: ['36'], color: ['azul', 'preto'] })
      end
      it { expect(subject.add_filter(:size, '36')).to eq(parameters: "tamanho-36_cor-azul-preto") }
    end

    context "when has accents" do
      before do
        search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'onça'] })
      end
      it { expect(subject.add_filter(:subcategory, 'Sandália')).to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-onca" }) }
      it { expect(subject.add_filter(:color, 'Onça' )).to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-onca" }) }
    end

    context "when paramter price order was passed" do
      subject { described_class.new({ category: 'sapato', sort: 'retail_price' }, "category", search_engine) }
      before do
        search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'onça'] })
      end
      it { expect(subject.add_filter(:color, 'Onça' )).to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-onca", "por" => 'menor-preco' }) }
    end

    context "when parameter per-page was passed" do
      subject { described_class.new({ category: 'sapato', per_page: '30' }, "category", search_engine) }
      before do
        search_engine.stub(:filters_applied).and_return({ category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'onça'] })
      end
      it { expect(subject.add_filter(:color, 'Onça' )).to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-onca", "por_pagina" => '30' }) }
    end
  end

end

