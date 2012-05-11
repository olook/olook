require 'spec_helper'

describe Catalog::Product do
  
  let(:product) do
    moment  = Factory.create :moment
    product = Factory.create :basic_shoe
    Catalog::Product.create :catalog => moment.catalog, :product => product
  end
  
  it { should belong_to(:catalog) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }
  it { product.should validate_uniqueness_of(:product_id).scoped_to([:catalog_id, :variant_id]) }
  
end
