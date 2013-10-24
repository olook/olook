# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::CatalogBase do
  it { should_not allow_value("CatalogHeader::CatalogBase").for(:type) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:url) }

  describe ".scopes" do

    before do
      FactoryGirl.create(:catalog_header, :text)
      FactoryGirl.create(:catalog_header, :big_banner)
      FactoryGirl.create(:catalog_header, :small_banner)
    end
    it "return only text type" do
      expect(described_class.with_type("CatalogHeader::TextCatalogHeader").count).to eql(1)
    end
    it "return without text type" do
      expect(described_class.with_type(["CatalogHeader::SmallBannerCatalogHeader", "CatalogHeader::BigBannerCatalogHeader"]).count).to eql(2)
    end
  end

  describe '.for_url' do
    it "should return Arel" do
      expect(CatalogHeader::CatalogBase.for_url('/sapato')).to respond_to(:all)
    end

    it "should find exact url" do
      bota = FactoryGirl.create(:catalog_header, :text, enabled: true, url: '/sapato/bota')
      expect(CatalogHeader::CatalogBase.for_url('/sapato/bota').first.id).to eq(bota.id)
    end
  end
end
