require 'spec_helper'

describe Clipping do
  describe '#validations' do
    it { should validate_presence_of(:logo) }
    it { should validate_presence_of(:clipping_text) }
    it { should validate_presence_of(:published_at) }
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:title) }
  end

  describe '.latest' do
    let!(:old_clipping) { FactoryGirl.create(:clipping, published_at: (Time.zone.now - 2.day)) }
    let!(:recent_clipping) { FactoryGirl.create(:clipping, published_at: (Time.zone.now - 1.day)) }

    subject { described_class.latest }

    it { should eq([recent_clipping, old_clipping]) }
  end
end
