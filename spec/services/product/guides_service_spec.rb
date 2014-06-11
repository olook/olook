describe Product::GuidesService do
  let(:old_detail) {"<p style=\"text-align: justify;\">Modelo Veste: P<BR>P: Cós Ø 88cm / Gancho 20cm<BR><b>Medidas Aproximadas:</b><BR>M: Cós Ø 90cm / Gancho cm<BR>G: Cós Ø 92cm / Gancho 21cm.</p"}
  let(:new_detail) {"P#P=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm;M=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm;G=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm"}
  context "In different style content" do
    context "When old" do
      it {expect(described_class.new(old_detail).new_style?).to be_false}
    end
    context "When new" do
      it {expect(described_class.new(new_detail).new_style?).to be_true}
    end
  end
  context "On old style" do
    it "return same string" do
      expect(described_class.new(old_detail).parse).to eql(old_detail)
    end

  end
  context "On new style" do
    before do
      @detail = described_class.new(new_detail)
      @detail_result = @detail.parse
    end
    it "return table header" do
      expect(@detail_result.fetch(:header)).to eql(['ombro','busto','quadril','comp.'])
    end
    it "return table keys content" do
      expect(@detail_result.fetch(:content)).to include("P" => [12,12,12,12],"M" => [12,12,12,12], "G" => [12,12,12,12])
    end
    it "return model size" do
      expect(@detail_result.fetch(:model_size)).to include("P")
    end
  end
end
