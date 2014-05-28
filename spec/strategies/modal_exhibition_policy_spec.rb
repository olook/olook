describe ModalExhibitionPolicy do
  context "when have to show" do
    context "and receive avaliable page" do
      it{expect(described_class.apply?(path: "/sapato")).to be_true}
    end
    context "and include possible number of views" do
      it{expect(described_class.apply?(path: "/sapato", cookie: ModalExhibitionPolicy::NUMBER_OF_VIEWS_TO_SHOW.first, mobile: false)).to be_true}
      it{expect(described_class.apply?(path: "/sapato", cookie: ModalExhibitionPolicy::NUMBER_OF_VIEWS_TO_SHOW.last, mobile: false)).to be_true}
    end
  end
  context "when don't have to show" do
    context "and receive unavaliable page" do
      it{expect(described_class.apply?(path: "/sacola")).to be_false}
    end
    context "and receive user" do
      it{expect(described_class.apply?(path: "/sapato", user: mock(:user))).to be_false}
    end
    context "and dont include possible number of views" do
      it{expect(described_class.apply?(path: "/sapato", cookie: "2204", mobile: false)).to be_false}
    end
  end



  context "when there is cookie" do
    context "and must show" do
    end
    context "and don't must show" do
    end
  end
end
