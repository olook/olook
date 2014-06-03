describe ZipCode::ValidService do
  context "when there is a valid zip code" do
    it{expect(described_class.apply?('08730810')).to be_true}
  end
  context "when there is a invalid zip code with" do
    context "more than permit number" do
      it{expect(described_class.apply?('0873089999999910')).to be_false}
    end
    context "less than permit number" do
      it{expect(described_class.apply?('087310')).to be_false}
    end
    context "empty string" do
      it{expect(described_class.apply?('')).to be_false}
    end
    context "nil" do
      it{expect(described_class.apply?(nil)).to be_false}
    end
  end
end
