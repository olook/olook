require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/full_look/look_profile_calculator'))
require 'ostruct'

describe FullLook::LookProfileCalculator do
  CASUAL_PROFILE = 1
  FASHION_PROFILE = 2
  SEXY_PROFILE = 3
  ELEGANCE_PROFILE = 4

  SHOE = 1
  BAG = 2
  ACCESSORY = 3
  CLOTH = 4

  context "there is more one profile than others" do
    context "when products have one profile" do
      before do
        @products = [
          mock('product', profiles: [OpenStruct.new(id: SEXY_PROFILE)], category: CLOTH),
          mock('product', profiles: [OpenStruct.new(id: CASUAL_PROFILE)], category: SHOE),
          mock('product', profiles: [OpenStruct.new(id: CASUAL_PROFILE)], category: BAG)
        ]
      end
      it { expect(described_class.calculate(@products)).to eql CASUAL_PROFILE }

      context 'when there is a category_weight' do
        before do
          @options = {
            category_weight: { CLOTH => 3, SHOE => 1, BAG => 1, ACCESSORY => 1 }
          }
        end
        it { expect(described_class.calculate(@products, @options)).to eql SEXY_PROFILE }
      end
    end
    context "when products have two profile" do
      before do
        @products = [
          mock('product', profiles: [OpenStruct.new(id: SEXY_PROFILE), OpenStruct.new(id: CASUAL_PROFILE)], category: CLOTH),
          mock('product', profiles: [OpenStruct.new(id: FASHION_PROFILE), OpenStruct.new(id: CASUAL_PROFILE)], category: SHOE),
          mock('product', profiles: [OpenStruct.new(id: FASHION_PROFILE), OpenStruct.new(id: SEXY_PROFILE)], category: BAG),
          mock('product', profiles: [OpenStruct.new(id: FASHION_PROFILE), OpenStruct.new(id: ELEGANCE_PROFILE)], category: ACCESSORY)
        ]
      end
      it { expect(described_class.calculate(@products)).to eql FASHION_PROFILE }

      context 'when there is a category_weight' do
        before do
          @options = {
            category_weight: { CLOTH => 3, SHOE => 1, BAG => 1, ACCESSORY => 1 }
          }
        end
        it { expect(described_class.calculate(@products, @options)).to eql SEXY_PROFILE }
      end
    end
  end
end

