# encoding: utf-8
require 'spec_helper'

describe SeoUrl do
  before do
    described_class.stub(:db_subcategories).and_return(["Amaciante","Bota"])
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
      it { expect(subject[:subcategory]).to eq 'bota' }

      it { expect(subject.keys).to include('care')  }
      it { expect(subject[:care]).to eq 'amaciante' }

      it { expect(subject.keys).to_not include('color')  }
      it { expect(subject[:color]).to be_nil }

      it { expect(subject.keys).to_not include('size')  }
      it { expect(subject[:size]).to be_nil }
    end

    context "when given parameters has brand and subcategory together" do
      subject { SeoUrl.parse("sapatos/bota/colcci-olook_conforto-amaciante") }
      it { expect(subject.keys).to include('subcategory')  }
      it { expect(subject[:subcategory]).to eq 'bota' }

      it { expect(subject.keys).to include('care')  }
      it { expect(subject[:care]).to eq 'amaciante' }      

      it { expect(subject.keys).to include('brand')  }
      it { expect(subject[:brand]).to eq 'colcci-olook' }
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

      it { expect(subject[:subcategory]).to eq 'bolsa media' }
    end

    context "when is ordering by minor price" do
      subject { SeoUrl.parse("sapato",{ "por" => "menor-preco" }) }

      it { expect(subject[:sort_price]).to eq 'retail_price' }
    end

    context "when is ordering by desc price" do
      subject { SeoUrl.parse("sapato",{ "por" => "maior-preco" }) }

      it { expect(subject[:sort_price]).to eq '-retail_price' }
    end
  end

  describe '.build' do
    context "when given parameters has subcategory and filters" do
      subject { SeoUrl.build(category: ['sapatos'], subcategory: ['amaciante'], size: ['36', 'p'], color: ['azul', 'vermelho']) }
      it { expect(subject).to eq({ parameters: "sapatos/tamanho-36-p_cor-azul-vermelho_conforto-amaciante" }) }
    end

    context "when given parameters has no subcategory" do
      subject { SeoUrl.build(category: ["sapatos"], size: ['36', 'p'], color: ['azul','vermelho']) }
      it { expect(subject).to eq({ parameters: "sapatos/tamanho-36-p_cor-azul-vermelho" }) }
    end

    context "when given parameters has subcategory, but not other filters" do
      subject { SeoUrl.build(category: ['sapatos'], subcategory: ['amaciante', 'bota']) }
      it { expect(subject).to eq({ parameters: "sapatos/bota_conforto-amaciante" }) }
    end

    context "when given parameters has brand and subcategory together" do
      subject { SeoUrl.build(category: [ 'sapatos' ], subcategory: ['bota'], brand: ['colcci', 'olook'], care:['amaciante']) }
      it { expect(subject).to eq({ parameters: "sapatos/bota-colcci-olook_conforto-amaciante" }) }
    end

    context "when there's no parameters and subcategories" do
      subject { SeoUrl.build(category: ["sapatos"]) }
      it { expect(subject).to eq({ parameters: "sapatos" }) }
    end

    context "when there's no subcategories but has filters" do
      subject { SeoUrl.build(category: ['sapato'], size: ['36'], color: ['azul', 'preto']) }
      it { expect(subject).to eq({ parameters: "sapato/tamanho-36_cor-azul-preto" }) }
    end

    context "when has accents" do
      it { expect(SeoUrl.build(category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho'])).
           to eq({ parameters: "sapato/sandalia/tamanho-36-p_cor-azul-vermelho" }) }
      it { expect(SeoUrl.build(category: ['sapato'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'])).
           to eq({ parameters: "sapato/rasteira/tamanho-36-p_cor-azul-onca" }) }
      it { expect(SeoUrl.build(category: ['Acessório'], subcategory: ['rasteira'], size: ['36', 'p'], color: ['azul', 'Onça'])).
           to eq({ parameters: "acessorio/rasteira/tamanho-36-p_cor-azul-onca" }) }
    end

    context "when paramter price order was passed" do
      it { expect(SeoUrl.build({ category: ['sapato'], subcategory: ['Sandália'], size: ['36', 'p'], color: ['azul', 'vermelho']}, por: 'menor-preco')).
          to eq({ parameters: "sapato/sandalia/tamanho-36-p_cor-azul-vermelho", por: 'menor-preco'} ) }
    end
  end
end
