# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::CustomUrlCatalogHeader do
  it { should validate_presence_of(:organic_url) }
  it { should validate_presence_of(:product_list) }
end

