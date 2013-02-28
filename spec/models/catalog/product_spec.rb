require 'spec_helper'

describe Catalog::Product do

  let(:product) do
    collection_theme  = FactoryGirl.create :collection_theme
    product = FactoryGirl.create(:shoe, :casual)
    Catalog::Product.create :catalog => collection_theme.catalog, :product => product
  end

  it { should belong_to(:catalog) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }
  it { product.should validate_uniqueness_of(:product_id).scoped_to([:catalog_id, :variant_id]) }

end
