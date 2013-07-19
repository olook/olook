# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:all_categories).and_return({ "Sapato" => [], "Roupa" => [], "Acessório" => [], "Bolsa" => [] })
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota", "Camiseta"])
    described_class.stub(:db_brands).and_return(["Colcci","Olook"])
  end

  describe ".new_parse" do
    it { expect(described_class.new({}).new_parse).to be_a(Hash)  }
    context "Main keys" do
      context "that include collection themes" do
        subject { described_class.new({collection_theme: 'p&b'}) }
        it { expect(subject.new_parse).to have_key(:collection_theme)  }
        it { expect(subject.new_parse[:collection_theme]).to eq('p&b') }
      end
      context "that includes brands" do
        subject { described_class.new({brand: 'olook'}) }
        it { expect(subject.new_parse).to have_key(:brand)  }
        it { expect(subject.new_parse[:brand]).to eq('olook') }
      end
      context "that includes brands" do
        subject { described_class.new({category: 'sapato'}) }
        it { expect(subject.new_parse).to have_key(:category)  }
        it { expect(subject.new_parse[:category]).to eq('sapato') }
      end
    end
    context "Main keys and filters" do
      context "that includes brands as main category as filter" do
        subject { described_class.new({brand: 'olook', parameters: 'sapato'}) }
        it { expect(subject.new_parse[:brand]).to eq('olook') }
        it { expect(subject.new_parse[:category]).to eq('sapato') }
      end
      context "that includes category as main" do
        context "brands as filter" do
          context "one brand" do
            subject { described_class.new({category: 'sapato', parameters: 'olook'}) }
            it { expect(subject.new_parse[:category]).to eq('sapato') }
            it { expect(subject.new_parse[:brand]).to eq('Olook') }
          end
          context "multiple brands" do
            subject { described_class.new({category: 'sapato', parameters: 'olook-colcci'}) }
            it { expect(subject.new_parse[:category]).to eq('sapato') }
            it { expect(subject.new_parse[:brand]).to eq('Olook-Colcci') }
          end
        end
        context "and filtering by care products" do
          subject { described_class.new({category: 'sapato', parameters: 'conforto-amaciante-palmilha'}) }
          it { expect(subject.new_parse[:category]).to eq('sapato') }
          it { expect(subject.new_parse[:care]).to eq('amaciante-palmilha') }
        end
      end
      context "filtering by subcategory" do
        context "one subcategory" do
          subject { described_class.new({category: 'sapato', parameters: 'bota'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
        end
        context "multiple subcategories" do
          subject { described_class.new({category: 'sapato', parameters: 'bota-scarpin'}) }
          it { expect(subject.new_parse[:category]).to eq('sapato') }
          it { expect(subject.new_parse[:subcategory]).to eq('bota-scarpin') }
        end
      end
      context "filtering by colors and size" do
        context "one color" do
          subject { described_class.new({category: 'sapato', parameters: 'bota/cor-azul'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
          it { expect(subject.new_parse[:color]).to eq('azul') }
        end
        context "one size" do
          subject { described_class.new({category: 'sapato', parameters: 'bota/tamanho-37'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
          it { expect(subject.new_parse[:size]).to eq('37') }
        end
        context "multiple colors" do
          subject { described_class.new({category: 'sapato', parameters: 'bota/cor-azul-amarelo'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
          it { expect(subject.new_parse[:color]).to eq('azul-amarelo') }
        end
        context "multiple sizes" do
          subject { described_class.new({category: 'sapato', parameters: 'bota/tamanho-37-40'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
          it { expect(subject.new_parse[:size]).to eq('37-40') }
        end
        context "colors and sizes" do
          subject { described_class.new({category: 'sapato', parameters: 'bota/cor-azul_tamanho-37'}) }
          it { expect(subject.new_parse[:subcategory]).to eq('bota') }
          it { expect(subject.new_parse[:color]).to eq('azul') }
          it { expect(subject.new_parse[:size]).to eq('37') }
        end
      end
    end

    context "filtering by ordenation" do
      context "lower price" do
        subject { described_class.new({ category: 'sapato', por: 'menor-preco' }) }
        it { expect(subject.new_parse[:sort]).to eq('retail_price') }
      end

      context "greater price" do
        subject { described_class.new({ category: 'sapato', por: 'maior-preco' }) }
        it { expect(subject.new_parse[:sort]).to eq('-retail_price') }
      end

      context "lower discount" do
        subject { described_class.new({ category: 'sapato', por: 'maior-desconto' }) }
        it { expect(subject.new_parse[:sort]).to eq('-desconto') }
      end
    end

    context "ordering by price range" do
      subject { described_class.new({ category: 'sapato', preco: '100-300' }) }
      it { expect(subject.new_parse[:price]).to eq('100-300') }
    end
  end

  describe '.build_for' do
    subject { described_class }

    context "when catalogs is being passed as a current_key" do
      context "when given parameters has subcategory and filters" do
        subject { SeoUrl.build_for("category", { category: ['sapato'], subcategory: ['Bota'], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']}) }
        it { expect(subject).to eq({ parameters: "bota/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has no subcategory" do
        subject { SeoUrl.build_for("category", { category: ["sapato"], size: ['36', 'p'], color: ['azul','vermelho']}) }
        it { expect(subject).to eq({ parameters: "tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has subcategory, but not other filters" do
        subject { SeoUrl.build_for("category", { category: ['sapato'], care: ['amaciante'], subcategory: ['bota']}) }
        it { expect(subject).to eq({ parameters: "bota/conforto-amaciante" }) }
      end

      context "when given parameters has brand and subcategory together" do
        subject { SeoUrl.build_for("category", { category: [ 'roupa' ], subcategory: ['bota'], brand: ['colcci', 'olook'], care:['amaciante']} ) }
        it { expect(subject).to eq({ parameters: "colcci-olook-bota/conforto-amaciante" }) }
      end

      context "when there's no parameters and subcategories" do
        subject { SeoUrl.build_for("category", { category: ["sapato"] }) }
        it { expect(subject).to eq({ parameters: "" }) }
      end

      context "when there's no subcategories but has filters" do
        subject { SeoUrl.build_for("category", { category: ['sapato'], size: ['36'], color: ['azul', 'preto'] }) }
        it { expect(subject).to eq({ parameters: "tamanho-36_cor-azul-preto" }) }
      end
    end

    context "when brand is being passed as a current_key" do
      context "and any subcategory wasn't passed" do
        it { expect(SeoUrl.build_for("brand", { brand: ['colcci'] }))
             .to eq({ parameters: ""} ) }
      end

      context "and any subcategory was passed without category" do
        it { expect(SeoUrl.build_for("brand", { brand: ['colcci'], subcategory: ['Jaqueta'] }))
             .to eq({ parameters: "jaqueta"} ) }
      end

      context "and more than one subcategory were passed without category" do
        it { expect(SeoUrl.build_for("brand", { brand: ['colcci'], subcategory: ['Jaqueta','camiseta'] }))
             .to eq({ parameters: "jaqueta-camiseta"} ) }
      end

      context "and any category was passed without subcategory" do
        it { expect(SeoUrl.build_for("brand", { brand: ['colcci'], category: ['Roupa'] }))
             .to eq({ parameters: "roupa"} ) }
      end

      context "and category, subcategory was passed" do
        it { expect(SeoUrl.build_for("brand", { brand: ['colcci'], category: ["roupa"], subcategory: ['Jaqueta'] }))
             .to eq({ parameters: "roupa-jaqueta"} ) }
      end

      context "when given parameters has only filters" do
        subject { SeoUrl.build_for("brand", { brand: ['colcci'], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho'] }) }
        it { expect(subject).to eq({ parameters: "conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has category and filters" do
        subject { SeoUrl.build_for("brand", { brand: ['colcci'], category: ["roupa"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho'] }) }
        it { expect(subject).to eq({ parameters: "roupa/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has subcategory and filters" do
        subject { SeoUrl.build_for("brand", { brand: ['colcci'], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho'] }) }
        it { expect(subject).to eq({ parameters: "camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has subcategory and filters and price" do
        subject { SeoUrl.build_for("brand", { brand: ['colcci'], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']} , { price: ['0', '309'], "sort" => 'retail_price'} ) }
        it { expect(subject).to eq({ parameters: "camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho", "preco" => "0-309", "por"=>"menor-preco" }) }
      end

      context "when given parameters has category, subcategory and filters" do
        subject { SeoUrl.build_for("brand", brand: ['colcci'], category: ["roupa"], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
        it { expect(subject).to eq({ parameters: "roupa-camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

    end

    context "when has accents" do
      it { expect(SeoUrl.build_for("category", { category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho'] } )).
           to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-vermelho" }) }
      it { expect(SeoUrl.build_for("category", { category: ['sapato'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'] } )).
           to eq({ parameters: "rasteira/tamanho-36-p_cor-azul-onca" }) }
      it { expect(SeoUrl.build_for("category", { category: ['Acessório'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'] })).
           to eq({ parameters: "rasteira/tamanho-36-p_cor-azul-onca" }) }
    end

    context "when paramter price order was passed" do
      it { expect(SeoUrl.build_for("category", { category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho']}, sort: 'retail_price')).
           to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-vermelho", "por" => "menor-preco"} ) }
    end

    context "when parameter per-page was passed" do
      it { expect(SeoUrl.build_for("category", { category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho']}, sort: 'retail_price', per_page: '30')).
           to eq({ parameters: "sandalia/tamanho-36-p_cor-azul-vermelho", "por" => "menor-preco", "por_pagina" => "30"} ) }
    end
  end
end
