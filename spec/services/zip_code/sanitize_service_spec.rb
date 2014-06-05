describe ZipCode::SanitizeService do
  context "when there is a valid zip code" do
    it "return clean zip code" do
      zip = '08730-810'
      expect(described_class.clean(zip)).to eql('08730810')
    end
  end
end

