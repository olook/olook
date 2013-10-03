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
      expect(described_class.without_type("CatalogHeader::TextCatalogHeader").count).to eql(2)
    end
  end
end
