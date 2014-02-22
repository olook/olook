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
      before do
        @description = described_class.new description_key: "alpargata"
      end
      it "return default description" do
        expect(@description.choose).to eql YAML::load(File.open(Seo::DescriptionManager::FILENAME))["alpargata"]
      end
    end
  end
end
