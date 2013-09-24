require 'spec_helper'
describe VariantObserver do
  context 'when changing inventory to 0' do
    it 'deletes view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Product.any_instance.should_receive(:delete_cache)
      @product.variants.each { |v| v.update_attributes(inventory: 0) }
    end
  end

  context 'when changing inventory from 0 to more' do
    it 'deletes view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :sold_out)
      Product.any_instance.should_receive(:delete_cache)
      @product.variants.each { |v| v.update_attributes(inventory: 10) }
    end
  end

  context 'when changing other things on variant' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Product.any_instance.should_not_receive(:delete_cache)
      @product.variants.each { |v| v.update_attributes(price: 1000.0) }
    end
  end

  context 'when changing inventory variant from > 0 to > 0' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :in_stock)
      Product.any_instance.should_not_receive(:delete_cache)
      @product.variants.each { |v| v.update_attributes(inventory: 10) }
    end
  end

  context 'when changing inventory variant from 0 to 0' do
    it 'keep view/product_item partial cache' do
      @product = FactoryGirl.create(:shoe, :sold_out)
      Product.any_instance.should_not_receive(:delete_cache)
      @product.variants.each { |v| v.update_attributes(inventory: 0) }
    end
  end
end
