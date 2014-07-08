# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ValueAdjustment do
  describe "calculate" do
    def cart_item(opts={})
      _cart_item = double('cart_item')
      _cart_item.stub(id: rand(1000),
                      product: stub(id: rand(1000)),
                      variant: stub(price: opts[:price],
                                    retail_price: opts[:retail_price] || opts[:price]),
                      quantity: opts[:quantity] || 1)
      _cart_item
    end

    it "has adjustments" do
      ci = cart_item(price: 100)
      subject.calculate([ ci ], {'param' => "20"}).should eq([{id: ci.id, product_id: ci.product.id, adjustment: 20}])
    end

    it "has adjustments superior of price" do
      ci = cart_item(price: 100)
      subject.calculate([ ci ], {'param' => "200"}).should eq([{id: ci.id, product_id: ci.product.id, adjustment: 100}])
    end

    it "has adjustments with two items" do
      ci1 = cart_item(price: 80)
      ci2 = cart_item(price: 200)
      subject.calculate([ ci1, ci2 ], {'param' => "200"}).should eq([{id: ci1.id, product_id: ci1.product.id, adjustment: 80}, {id: ci2.id, product_id: ci2.product.id, adjustment: 120}])
    end

    context "with full_price = 2" do
      it "should not apply discount when markdown is an advantage" do
        ci =  cart_item(price: 200, retail_price: 120)
        subject.calculate([ ci ], {'param' => '20', 'full_price' => '2'}).should eq([{id: ci.id, product_id: ci.product.id, adjustment: 0}])
      end
    end
  end
end
