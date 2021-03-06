# -*- encoding : utf-8 -*-
describe HeelSanitize do
  context 'initialize with word' do
    it "When word is 'baixo'" do
      expect(described_class.new('baixo').perform).to eql('0-4 cm')
    end
    it "When word is 'medio'" do
      expect(described_class.new('médio').perform).to eql('5-9 cm')
    end
    it "When word is 'alto'" do
      expect(described_class.new('alto').perform).to eql('10-15 cm')
    end
  end
end
