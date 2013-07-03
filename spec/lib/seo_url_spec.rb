# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:all_categories).and_return({ "Sapato" => [], "Roupa" => [], "Acessório" => [], "Bolsa" => [] })
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota", "Camiseta"])
    described_class.stub(:db_brands).and_return(["Colcci","Olook"])
  end
  describe ".parse" do
    context "when given parameters has subcategory and filters" do
      subject { SeoUrl.parse("sapato/conforto-amaciante_tamanho-36-p_cor-azul-vermelho") }

      it { expect(subject).to be_a(Hash)  }
      it { expect(subject.keys).to include('size')  }
      it { expect(subject[:size]).to eq '36-p' }

      it { expect(subject.keys).to include('color')  }
      it { expect(subject[:color]).to eq 'azul-vermelho' }

      it { expect(subject.keys).to include('care')  }
      it { expect(subject[:care]).to eq 'amaciante' }

      context "should have access with string key" do
        it { expect(subject['care']).to eq 'amaciante' }
        it { expect(subject['color']).to eq 'azul-vermelho' }
        it { expect(subject['size']).to eq '36-p' }

      end


      context "when given parameters has no subcategory" do
        subject { SeoUrl.parse("sapato/tamanho-36-p_cor-azul-vermelho") }
        it { expect(subject.keys).to_not include('subcategory')  }
        it { expect(subject[:subcategory]).to be_nil }

        it { expect(subject.keys).to include('size')  }
        it { expect(subject[:size]).to eq '36-p' }

        it { expect(subject.keys).to include('color')  }
        it { expect(subject[:color]).to eq 'azul-vermelho' }
      end

      context "when given parameters has subcategory, but not other filters" do
        subject { SeoUrl.parse("sapato/bota/conforto-amaciante") }
        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'Bota' }

        it { expect(subject.keys).to include('care')  }
        it { expect(subject[:care]).to eq 'amaciante' }

        it { expect(subject.keys).to_not include('color')  }
        it { expect(subject[:color]).to be_nil }

        it { expect(subject.keys).to_not include('size')  }
        it { expect(subject[:size]).to be_nil }
      end

      context "when given parameters has brand and subcategory together" do
        subject { SeoUrl.parse("roupa/bota-colcci-olook") }
        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'Bota' }

        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq "Olook-Colcci" }
      end

      context "when there's no parameters and subcategories" do
        subject { SeoUrl.parse("sapatos") }

        it { expect(subject.keys).to include('category')  }
        it { expect(subject[:category]).to eq 'sapatos' }
        it { expect(subject[:subcategory]).to be_nil }
        it { expect(subject[:brand]).to be_nil }
        it { expect(subject[:size]).to be_nil }
        it { expect(subject[:color]).to be_nil }
      end

      context "when there's no subcategories but has filters" do
        subject { SeoUrl.parse("sapato/tamanho-36_cor-azul-preto") }

        it { expect(subject[:category]).to eq 'sapato' }
        it { expect(subject[:subcategory]).to be_nil }
        it { expect(subject[:size]).to eq '36' }
        it { expect(subject[:color]).to eq 'azul-preto' }
      end

      context "when there's subcategory with space and accent" do
        before do
          described_class.stub(:db_subcategories).and_return(["Bolsa Média"])
        end
        subject { SeoUrl.parse("sapato/bolsa media") }

        it { expect(subject[:subcategory]).to eq 'Bolsa Media' }
      end

      context "when is ordering by minor price" do
        subject { SeoUrl.parse("sapato",{ "por" => "menor-preco" }) }

        it { expect(subject[:sort_price]).to eq 'menor-preco' }
      end

      context "when is ordering by desc price" do
        subject { SeoUrl.parse("sapato",{ "por" => "maior-preco" }) }

        it { expect(subject[:sort_price]).to eq 'maior-preco' }
      end
    end
  end

  describe ".parse_brands" do
    context "when given parameters has subcategory and filters" do
      subject { SeoUrl.parse_brands("colcci/camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho") }

      it { expect(subject).to be_a(Hash)  }
      it { expect(subject.keys).to include('size')  }
      it { expect(subject[:size]).to eq '36-p' }

      it { expect(subject[:brand]).to eq 'colcci' }
      it { expect(subject[:subcategory]).to eq 'camiseta' }

      it { expect(subject.keys).to include('color')  }
      it { expect(subject[:color]).to eq 'azul-vermelho' }

      it { expect(subject.keys).to include('care')  }
      it { expect(subject[:care]).to eq 'amaciante' }

      context "should have access with string key" do
        it { expect(subject['care']).to eq 'amaciante' }
        it { expect(subject['color']).to eq 'azul-vermelho' }
        it { expect(subject['size']).to eq '36-p' }
      end


      context "when given parameters hasn't got any parameters but brand" do
        subject { SeoUrl.parse_brands("colcci") }
        it { expect(subject.keys.size).to eq 3}
        it { expect(subject[:brand]).to eq 'colcci' }
      end

      context "when given parameters has subcategory and brand, but not other filters" do
        subject { SeoUrl.parse_brands("colcci/bota") }
        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'bota' }
        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'colcci' }

        it { expect(subject.keys.size).to eq 4}
      end

      context "when given parameters has many subcategories and brand, but not other filters" do
        subject { SeoUrl.parse_brands("colcci/bota-scarpin") }
        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'bota-scarpin' }
        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'colcci' }

        it { expect(subject.keys.size).to eq 4}
      end

      context "when given parameters has brand, category and subcategory together" do
        subject { SeoUrl.parse_brands("colcci/roupa/bota") }

        it { expect(subject.keys).to include('category')  }
        it { expect(subject[:category]).to eq 'roupa' }

        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'bota' }

        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'colcci' }

        it { expect(subject.keys.size).to eq 5}
      end

      context "when given parameters has brand, category and many subcategories together" do
        subject { SeoUrl.parse_brands("colcci/roupa/bota-scarpin") }

        it { expect(subject.keys).to include('category')  }
        it { expect(subject[:category]).to eq 'roupa' }

        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'bota-scarpin' }

        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'colcci' }

        it { expect(subject.keys.size).to eq 5}
      end


      context "when given parameters has brand, category and many subcategories together" do
        subject { SeoUrl.parse_brands("olook/bolsa/carteira-bolsa") }

        it { expect(subject.keys).to include('category')  }
        it { expect(subject[:category]).to eq 'bolsa' }

        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'carteira-bolsa' }

        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'olook' }
      end

      context "when given parameters has brand, category, subcategory and filters together" do
        subject { SeoUrl.parse_brands("colcci/roupa/bota/conforto-amaciante_tamanho-36-p_cor-azul-vermelho") }

        it { expect(subject.keys).to include('category')  }
        it { expect(subject[:category]).to eq 'roupa' }

        it { expect(subject.keys).to include('subcategory')  }
        it { expect(subject[:subcategory]).to eq 'bota' }

        it { expect(subject.keys).to include('brand')  }
        it { expect(subject[:brand]).to eq 'colcci' }

        it { expect(subject.keys).to include('size')  }
        it { expect(subject[:size]).to eq '36-p' }

        it { expect(subject.keys).to include('color')  }
        it { expect(subject[:color]).to eq 'azul-vermelho' }

        it { expect(subject.keys).to include('care')  }
        it { expect(subject[:care]).to eq 'amaciante' }

      end
    end
  end

  describe '.build_for_catalogs' do
    context "when catalogs is being passed as a parameter" do
      subject { described_class }
      it "delegates to build_for_catalogs" do
        subject.should_receive(:build_for_catalogs)
        subject.build_for_catalogs(category: ["sapato"])
      end

      context "when given parameters has subcategory and filters" do
        subject { SeoUrl.build_for_catalogs(category: ['sapato'], subcategory: ['Bota'], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
        it { expect(subject).to eq({ parameters: "sapato/bota/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has no subcategory" do
        subject { SeoUrl.build_for_catalogs(category: ["sapato"], size: ['36', 'p'], color: ['azul','vermelho']) }
        it { expect(subject).to eq({ parameters: "sapato/tamanho-36-p_cor-azul-vermelho" }) }
      end

      context "when given parameters has subcategory, but not other filters" do
        subject { SeoUrl.build_for_catalogs(category: ['sapato'], care: ['amaciante'], subcategory: ['bota']) }
        it { expect(subject).to eq({ parameters: "sapato/bota/conforto-amaciante" }) }
      end

      context "when given parameters has brand and subcategory together" do
        subject { SeoUrl.build_for_catalogs(category: [ 'roupa' ], subcategory: ['bota'], brand: ['colcci', 'olook'], care:['amaciante']) }
        it { expect(subject).to eq({ parameters: "roupa/colcci-olook-bota/conforto-amaciante" }) }
      end

      context "when there's no parameters and subcategories" do
        subject { SeoUrl.build_for_catalogs(category: ["sapato"]) }
        it { expect(subject).to eq({ parameters: "sapato" }) }
      end

      context "when there's no subcategories but has filters" do
        subject { SeoUrl.build_for_catalogs(category: ['sapato'], size: ['36'], color: ['azul', 'preto']) }
        it { expect(subject).to eq({ parameters: "sapato/tamanho-36_cor-azul-preto" }) }
      end

      context "when has accents" do
        it { expect(SeoUrl.build_for_catalogs(category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho'])).
             to eq({ parameters: "sapato/sandalia/tamanho-36-p_cor-azul-vermelho" }) }
        it { expect(SeoUrl.build_for_catalogs(category: ['sapato'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'])).
             to eq({ parameters: "sapato/rasteira/tamanho-36-p_cor-azul-onca" }) }
        it { expect(SeoUrl.build_for_catalogs(category: ['Acessório'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'])).
             to eq({ parameters: "acessorio/rasteira/tamanho-36-p_cor-azul-onca" }) }
      end

      context "when paramter price order was passed" do
        it { expect(SeoUrl.build_for_catalogs({ category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho']}, por: 'menor-preco')).
             to eq({ parameters: "sapato/sandalia/tamanho-36-p_cor-azul-vermelho?por=menor-preco"} ) }
      end

    end
  end

  describe ".build_for_brands"

  context "when brands is being passed as a parameter" do
    subject { described_class }

    context "and any subcategory wasn't passed" do
      it { expect(SeoUrl.build_for_brands({ brand: ['colcci'] }))
           .to eq({ parameters: "colcci"} ) }
    end

    context "and any subcategory was passed without category" do
      it { expect(SeoUrl.build_for_brands({ brand: ['colcci'], subcategory: ['Jaqueta'] }))
           .to eq({ parameters: "colcci/jaqueta"} ) }
    end

    context "and more than one subcategory were passed without category" do
      it { expect(SeoUrl.build_for_brands({ brand: ['colcci'], subcategory: ['Jaqueta','camiseta'] }))
           .to eq({ parameters: "colcci/jaqueta-camiseta"} ) }
    end

    context "and any category was passed without subcategory" do
      it { expect(SeoUrl.build_for_brands({ brand: ['colcci'], category: ['Roupa'] }))
           .to eq({ parameters: "colcci/roupa"} ) }
    end

    context "and category, subcategory was passed" do
      it { expect(SeoUrl.build_for_brands({ brand: ['colcci'], category: ["roupa"], subcategory: ['Jaqueta'] }))
           .to eq({ parameters: "colcci/roupa/jaqueta"} ) }
    end

    context "when given parameters has only filters" do
      subject { SeoUrl.build_for_brands(brand: ['colcci'], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
      it { expect(subject).to eq({ parameters: "colcci/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
    end

    context "when given parameters has category and filters" do
      subject { SeoUrl.build_for_brands(brand: ['colcci'], category: ["roupa"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
      it { expect(subject).to eq({ parameters: "colcci/roupa/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
    end

    context "when given parameters has subcategory and filters" do
      subject { SeoUrl.build_for_brands(brand: ['colcci'], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
      it { expect(subject).to eq({ parameters: "colcci/camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
    end

    context "when given parameters has subcategory and filters and price" do
      subject { SeoUrl.build_for_brands({ brand: ['colcci'], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']} , { price: ['0', '309'], "por" => 'menor-preco'} ) }
      it { expect(subject).to eq({ parameters: "colcci/camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho?preco=0-309&por=menor-preco" }) }
    end

    context "when given parameters has category, subcategory and filters" do
      subject { SeoUrl.build_for_brands(brand: ['colcci'], category: ["roupa"], subcategory: ["camiseta"], care: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
      it { expect(subject).to eq({ parameters: "colcci/roupa/camiseta/conforto-amaciante_tamanho-36-p_cor-azul-vermelho" }) }
    end
  end
end
