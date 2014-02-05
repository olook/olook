# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::BigBannerCatalogHeader do
  it { should validate_presence_of(:big_banner) }
  it { should validate_presence_of(:link_big_banner) }
  it { should validate_presence_of(:alt_big_banner) }
end

