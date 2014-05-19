describe ModalExhibitionPolicy do
  context "when receive avaliable page" do
    it{expect(described_class.apply?(path: "/sapato")).to be_true}
  end
  context "when receive unavaliable page" do
    it{expect(described_class.apply?(path: "/sacola")).to be_false}
  end
  context "when receive user" do
    it{expect(described_class.apply?(path: "/sapato", user: mock(:user))).to be_false}
  end
  context "when receive cookie" do
    it{expect(described_class.apply?(path: "/sapato", cookie: mock(:cookie))).to be_false}
  end
end
