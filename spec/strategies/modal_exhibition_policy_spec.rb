describe ModalExhibitionPolicy do
  context "when receive avaliable page" do
    it{expect(described_class.apply?("/sapato", nil)).to be_true}
  end
  context "when receive unavaliable page" do
    it{expect(described_class.apply?("/sacola", nil)).to be_false}
  end
end
