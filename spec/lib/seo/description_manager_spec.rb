describe Seo::DescriptionManager do
  describe ".choose_description" do
    context "When dont have description" do
      it "return default description" do
        expect(subject.choose).to eql Seo::DescriptionManager::DEFAULT
      end
    end
    context "when dont find key" do
      before do
        @description = described_class.new description_key: "not_found"
      end
      it "return default description" do
        expect(@description.choose).to eql Seo::DescriptionManager::DEFAULT
      end
    end
    context "when find key" do
      context "lowercase" do
        before do
          @description = described_class.new description_key: "alpargata"
        end
        it "return alpargata description" do
          expect(@description.choose).to eql YAML::load(File.open(Seo::DescriptionManager::FILENAME))["alpargata"]
        end
      end
      context "Upcase", focus: true  do
        before do
          @description = described_class.new description_key: "Alpargata"
        end
        it "return alpargata description" do
          expect(@description.choose).to eql YAML::load(File.open(Seo::DescriptionManager::FILENAME))["alpargata"]
        end
      end
      context "With space" do
        before do
          @description = described_class.new description_key: "bolsa media"
        end
        it "return bolsa media description" do
          expect(@description.choose).to eql YAML::load(File.open(Seo::DescriptionManager::FILENAME))["bolsa media"]
        end
      end
    end
  end
end
