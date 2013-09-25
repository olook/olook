# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::CatalogHeader do
  it { should_not allow_value("CatalogHeader::CatalogHeader").for(:type) }
  it { should validate_presence_of(:type) }
end
