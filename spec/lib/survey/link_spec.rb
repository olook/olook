# -*- encoding : utf-8 -*-
require 'yaml'
describe Survey::Link do
  before do
    filename = File.expand_path(File.join(File.dirname(__FILE__), '../../..', 'config/survey_link.yml'))
    @file = YAML::load(File.open(filename))
  end
  describe ".generate" do
    context "When buy only shoe" do
      before do
        @item = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
      end
      it "return shoe link" do
        expect(described_class.generate([@item])).to eql  @file["1"]
      end
    end
    context "When buy only accessory" do
      before do
        @item = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 3)), is_freebie: false)
      end
      it "return accessory link" do
        expect(described_class.generate([@item])).to eql @file["3"]
      end
    end
    context "When buy only bag" do
      before do
        @item = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 2)), is_freebie: false)
      end
      it "return bag link" do
        expect(described_class.generate([@item])).to eql @file["2"]
      end
    end
    context "When buy only cloth" do
      before do
        @item = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 4)), is_freebie: false)
      end
      it "return cloth link" do
        expect(described_class.generate([@item])).to eql @file["4"]
      end
    end
    context "When buy shoe and bag" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 2)), is_freebie: false)
      end
      it "return shoe bag link" do
        expect(described_class.generate([@item1,@item2])).to eql @file["1_2"]
      end
    end
    context "When buy bag and shoe" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 2)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
      end
      it "return shoe bag link" do
        expect(described_class.generate([@item1,@item2])).to eql @file["1_2"]
      end
    end
    context "When buy same product" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
      end
      it "return shoe bag link" do
        expect(described_class.generate([@item1,@item2])).to eql @file["1"]
      end
    end
    context "When buy 3 categories" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 3)), is_freebie: false)
        @item3 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 4)), is_freebie: false)
      end
      it "return tree categories link" do
        expect(described_class.generate([@item1,@item3,@item2])).to eql @file["1_3_4"]
      end
    end
    context "When buy all categories" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 3)), is_freebie: false)
        @item3 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 4)), is_freebie: false)
        @item4 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 2)), is_freebie: false)
        @item5 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
      end
      it "return all categories link" do
        expect(described_class.generate([@item1,@item3,@item2,@item5,@item4])).to eql @file["1_2_3_4"]
      end
    end
    context "When buy a different cloth category" do
      before do
        @item1 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 1)), is_freebie: false)
        @item2 = mock('LineItem', variant: mock('Variant', product: mock('Product', category: 6)), is_freebie: false)
      end
      it "return shoe bag link" do
        expect(described_class.generate([@item1,@item2])).to eql @file["1_4"]
      end
    end
  end
end
