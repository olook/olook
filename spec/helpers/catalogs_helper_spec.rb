require 'spec_helper'

describe CatalogsHelper do
  describe "#titleize_without_pronoum" do
    context "argument without pronoum" do
      it { expect(helper.titleize_without_pronoum('anabela')).to eql 'Anabela' }
      it { expect(helper.titleize_without_pronoum('anabela carneiro')).to eql 'Anabela Carneiro' }
    end

    context "argument with pronoum" do
      it { expect(helper.titleize_without_pronoum('anabela de carneiro')).to eql 'Anabela de Carneiro' }
      it { expect(helper.titleize_without_pronoum('Casaco E Jaqueta')).to eql 'Casaco e Jaqueta' }
      it { expect(helper.titleize_without_pronoum('De Casaco E Jaqueta')).to eql 'De Casaco e Jaqueta' }
    end
  end
end
