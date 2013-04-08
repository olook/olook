require 'spec_helper'
describe ProductObserver do
  context 'when changing inventory to 0' do
    it 'deletes view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
      @product.variants.each { |v| v.update_attributes(inventory: 0) }
      expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to be_nil
    end
  end

  context 'when changing inventory from 0 to more' do
    it 'deletes view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :sold_out)
      Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
      @product.variants.each { |v| v.update_attributes(inventory: 10) }
      expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to be_nil
    end
  end

  context 'when changing other things on variant' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
      @product.variants.each { |v| v.update_attributes(price: 1000.0) }
      expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to eq('test')
    end
  end

  context 'when changing inventory variant from > 0 to > 0' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
      @product.variants.each { |v| v.update_attributes(inventory: 10) }
      expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to eq('test')
    end
  end

  context 'when changing inventory variant from 0 to 0' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :sold_out)
      Rails.cache.write("views/#{@product.item_view_cache_key_for}", "test")
      @product.variants.each { |v| v.update_attributes(inventory: 0) }
      expect( Rails.cache.read("views/#{@product.item_view_cache_key_for}") ).to eq('test')
    end
  end
end
