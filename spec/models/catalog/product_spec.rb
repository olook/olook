# == Schema Information
#
# Table name: catalog_products
#
#  id                     :integer          not null, primary key
#  catalog_id             :integer
#  product_id             :integer
#  category_id            :integer
#  subcategory_name       :string(255)
#  subcategory_name_label :string(255)
#  shoe_size              :integer
#  shoe_size_label        :string(255)
#  heel                   :string(255)
#  heel_label             :string(255)
#  original_price         :decimal(10, 2)
#  retail_price           :decimal(10, 2)
#  discount_percent       :float
#  variant_id             :integer
#  inventory              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Catalog::Product do
  
  let(:product) do
    moment  = FactoryGirl.create :moment
    product = FactoryGirl.create :basic_shoe
    Catalog::Product.create :catalog => moment.catalog, :product => product
  end
  
  it { should belong_to(:catalog) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }
  it { product.should validate_uniqueness_of(:product_id).scoped_to([:catalog_id, :variant_id]) }
  
end
