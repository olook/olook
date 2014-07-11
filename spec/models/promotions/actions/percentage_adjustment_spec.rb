# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PercentageAdjustment do
  describe "#calculate" do
    def cart_item(attr={})
      cart_item = double('cart_item')
      cart_item.stub(id: rand(1000),
                     product: stub(id: rand(1000)),
                     quantity: attr[:quantity] || 1,
                     variant: stub(price: attr[:price],
                                   retail_price: attr[:retail_price] || attr[:price]),
                     )
      cart_item
    end
    it "calculate percent discount" do
      ci = cart_item(price: 110)
      expect(subject.calculate([ci], { 'param' => '20' })).
        to eq([{id: ci.id, product_id: ci.product.id, adjustment: 22}])
    end

    context "when filter full_price = -1 (todos os produtos do site)" do
      it "markdown item calculate percent over retail_price" do
        ci = cart_item(price: 110, retail_price: 80)
        expect(subject.calculate([ci], { 'param' => '10', 'full_price' => '-1' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 8}])
      end
    end

    context "when filter full_price = 0 (somente produtos com markdown)" do
      it "calculate percent over retail_price" do
        ci = cart_item(price: 110, retail_price: 80)
        expect(subject.calculate([ci], { 'param' => '20', 'full_price' => '0' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 16}])
      end
    end

    context "when filter full_price = 1 (somente produtos full_price)" do
      it "does not have adjustment for markdown item" do
        ci = cart_item(price: 110, retail_price: 80)
        expect(subject.calculate([ci], { 'param' => '20', 'full_price' => '1' })).
          to eq([])
      end

      it "calculate over price" do
        ci = cart_item(price: 110, retail_price: 110)
        expect(subject.calculate([ci], { 'param' => '20', 'full_price' => '1' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 22}])
      end
    end

    context "when filter full_price = 2 (calcular o melhor desconto e aplicar)" do
      it "does not have adjustment for advantageous markdown item" do
        ci = cart_item(price: 110, retail_price: 80)
        expect(subject.calculate([ci], { 'param' => '10', 'full_price' => '2' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 0}])
      end

      it "calculate over price and have adjustment over retail_price for advantageous discount" do
        ci = cart_item(price: 110, retail_price: 100)
        expect(subject.calculate([ci], { 'param' => '20', 'full_price' => '2' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 12}])
      end

      it "calculate over price" do
        ci = cart_item(price: 110, retail_price: 110)
        expect(subject.calculate([ci], { 'param' => '10', 'full_price' => '2' })).
          to eq([{id: ci.id, product_id: ci.product.id, adjustment: 11}])
      end
    end
  end
end


