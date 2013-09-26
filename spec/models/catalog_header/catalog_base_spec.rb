# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::CatalogBase do
  it { should_not allow_value("CatalogHeader::CatalogBase").for(:type) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:url) }
end
