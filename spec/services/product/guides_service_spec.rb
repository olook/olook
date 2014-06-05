describe Product::GuidesService do
  let(:old_detail) {"<p style=\"text-align: justify;\">Modelo Veste: P<BR>P: Cós Ø 88cm / Gancho 20cm<BR><b>Medidas Aproximadas:</b><BR>M: Cós Ø 90cm / Gancho cm<BR>G: Cós Ø 92cm / Gancho 21cm.</p"}
  let(:new_detail) {"P#P=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm;M=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm;G=>ombro:12cm,busto:12cm,quadril:12cm,comp.:12cm"}
  context "In different style content" do
    context "When old" do
      it {expect(described_class.new(old_detail).old_style?).to be_true}
    end
    context "When new" do
      it {expect(described_class.new(new_detail).old_style?).to be_false}
    end
  end
  context "In new style",focus: true do
    it "return model size" do
      detail = described_class.new(new_detail)
      detail.process
      expect(detail.model_size).to eql("P")
    end
    it "return array" do
      detail = described_class.new(new_detail)
      
      expect(detail.process).to eql("P")
    end
  end
end
