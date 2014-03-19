# encoding: utf-8
require 'spec_helper'

describe Header do
  it { should_not allow_value("Header").for(:type) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:url) }

  describe ".scopes" do

    before do
      FactoryGirl.create(:catalog_base, :text)
      FactoryGirl.create(:catalog_base, :big_banner)
      FactoryGirl.create(:catalog_base, :small_banner)
    end
    it "return only text type" do
      expect(described_class.with_type("TextCatalogHeader").count).to eql(1)
    end
    it "return without text type" do
      expect(described_class.with_type(["SmallBannerCatalogHeader", "BigBannerCatalogHeader"]).count).to eql(2)
    end
  end

  describe '.for_url' do
    it "should return Arel" do
      expect(Header.for_url('/sapato')).to respond_to(:all)
    end

    it "should find exact url" do
      bota = FactoryGirl.create(:catalog_base, :text, enabled: true, url: '/sapato/bota')
      expect(Header.for_url('/sapato/bota').first.id).to eq(bota.id)
    end
  end
end
