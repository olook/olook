# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::SmallBannerCatalogHeader do
  it { should validate_presence_of(:medium_banner) }
  it { should validate_presence_of(:link_medium_banner) }
  it { should validate_presence_of(:alt_medium_banner) }
  it { should validate_presence_of(:small_banner1) }
  it { should validate_presence_of(:link_small_banner1) }
  it { should validate_presence_of(:alt_small_banner1) }
  it { should validate_presence_of(:small_banner2) }
  it { should validate_presence_of(:link_small_banner2) }
  it { should validate_presence_of(:alt_small_banner2) }
end

