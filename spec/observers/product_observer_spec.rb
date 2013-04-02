require 'spec_helper'
describe ProductObserver do
  it 'deletes view/product_item partial cache' do
    @product = FactoryGirl.create(:shoe, :in_stock)
    Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
    @product.variants.each { |v| v.update_attributes(inventory: 0) }
    expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to be_nil
  end
end
