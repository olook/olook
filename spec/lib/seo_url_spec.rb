require 'spec_helper'

describe SeoUrl do
  describe ".parse" do
    before do
      described_class.stub(:all_subcategories).and_return(["Amaciante","Bota"])
      described_class.stub(:all_brands).and_return(["Colcci","Olook"])
    end
    context "when given parameters has subcategory and filters" do
      subject { SeoUrl.parse("sapatos/amaciante/tamanho-36-p_cor-azul-vermelho") }

      it { expect(subject).to be_a(Hash)  }
      it { expect(subject.keys).to include('size')  }
      it { expect(subject['size']).to eq '36-p' }
      it { expect(subject[:size]).to eq '36-p' }

      it { expect(subject.keys).to include('color')  }
      it { expect(subject['color']).to eq 'azul-vermelho' }
      it { expect(subject[:color]).to eq 'azul-vermelho' }

      it { expect(subject.keys).to include('subcategory')  }
      it { expect(subject['subcategory']).to eq 'amaciante' }
      it { expect(subject[:subcategory]).to eq 'amaciante' }
    end

    context "when given parameters has no subcategory" do
      subject { SeoUrl.parse("sapatos/tamanho-36-p_cor-azul-vermelho") }
      it { expect(subject.keys).to_not include('subcategory')  }
      it { expect(subject['subcategory']).to be_nil }
      it { expect(subject[:subcategory]).to be_nil }

      it { expect(subject.keys).to include('size')  }
      it { expect(subject['size']).to eq '36-p' }
      it { expect(subject[:size]).to eq '36-p' }

      it { expect(subject.keys).to include('color')  }
      it { expect(subject['color']).to eq 'azul-vermelho' }
      it { expect(subject[:color]).to eq 'azul-vermelho' }
    end

    context "when given parameters has subcategory, but not other filters" do
      subject { SeoUrl.parse("sapatos/amaciante-bota") }
      it { expect(subject.keys).to include('subcategory')  }
      it { expect(subject['subcategory']).to eq 'amaciante-bota' }
      it { expect(subject[:subcategory]).to eq 'amaciante-bota' }

      it { expect(subject.keys).to_not include('color')  }
      it { expect(subject['color']).to be_nil }
      it { expect(subject[:color]).to be_nil }

      it { expect(subject.keys).to_not include('size')  }
      it { expect(subject['size']).to be_nil }
      it { expect(subject[:size]).to be_nil }
    end

    context "when given parameters has brand and subcategory together" do
      subject { SeoUrl.parse("sapatos/amaciante-bota-colcci-olook") }
      it { expect(subject.keys).to include('subcategory')  }
      it { expect(subject['subcategory']).to eq 'amaciante-bota' }
      it { expect(subject[:subcategory]).to eq 'amaciante-bota' }

      it { expect(subject.keys).to include('brand')  }
      it { expect(subject['brand']).to eq 'colcci-olook' }
      it { expect(subject[:brand]).to eq 'colcci-olook' }

    end

    context "when there's no parameters and subcategories" do
      subject { SeoUrl.parse("sapatos") }

      it { expect(subject.keys).to include('category')  }
      it { expect(subject['category']).to eq 'sapatos' }
      it { expect(subject[:category]).to eq 'sapatos' }

      it { expect(subject['subcategory']).to be_nil }
      it { expect(subject[:subcategory]).to be_nil }

      it { expect(subject['brand']).to be_nil }
      it { expect(subject[:brand]).to be_nil }

      it { expect(subject['size']).to be_nil }
      it { expect(subject[:size]).to be_nil }

      it { expect(subject['color']).to be_nil }
      it { expect(subject[:color]).to be_nil }

    end
  end
end
