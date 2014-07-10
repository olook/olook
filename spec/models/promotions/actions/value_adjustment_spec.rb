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

    context "has adjustments superior of price" do
      it "fix on item price" do
        ci = cart_item(price: 100)
        subject.calculate([ ci ], {'param' => "200"}).should eq([{id: ci.id, product_id: ci.product.id, adjustment: 100}])
      end

      it "three items fix on price" do
        ci = cart_item(price: 90)
        ci2 = cart_item(price: 70)
        ci3 = cart_item(price: 30)
        expect(subject.calculate([ ci, ci2, ci3 ], {'param' => "200"})).
          to eq([
            {id: ci3.id, product_id: ci3.product.id, adjustment: 30},
            {id: ci2.id, product_id: ci2.product.id, adjustment: 70},
            {id: ci.id, product_id: ci.product.id, adjustment: 90} ])

      end
    end

    it "distribute adjustments by item value with two items" do
      ci1 = cart_item(price: 80)
      ci2 = cart_item(price: 320)
      expect(subject.calculate([ ci1, ci2 ], {'param' => "200"})).
        to eq([
          {id: ci1.id, product_id: ci1.product.id, adjustment: 40},
          {id: ci2.id, product_id: ci2.product.id, adjustment: 160} ])
    end

    context "with full_price = 2" do
      it "should not apply discount when markdown is an advantage" do
        ci =  cart_item(price: 100, retail_price: 60)
        ci2 =  cart_item(price: 100, retail_price: 90)
        expect(subject.calculate([ ci, ci2 ], {'param' => '30', 'full_price' => '2'})).
          to eq([
            {id: ci.id, product_id: ci.product.id, adjustment: 0},
            {id: ci2.id, product_id: ci2.product.id, adjustment: 20} ])
      end

      it "should distribute discount taking full_price in consideration" do
        ci =  cart_item(price: 100, retail_price: 60)
        ci2 =  cart_item(price: 100, retail_price: 90)
        ci3 =  cart_item(price: 100)
        expect(subject.calculate([ ci, ci2, ci3 ], {'param' => '38', 'full_price' => '2'})).
          to eq([
            {id: ci.id, product_id: ci.product.id, adjustment: 0},
            {id: ci2.id, product_id: ci2.product.id, adjustment: 8},
            {id: ci3.id, product_id: ci3.product.id, adjustment: 20}
        ])
      end

      it "should distribute discount taking full_price in consideration" do
        ci =  cart_item(price: 20)
        ci2 =  cart_item(price: 100, retail_price: 50)
        expect(subject.calculate([ ci, ci2 ], {'param' => '14', 'full_price' => '2'})).
          to eq([
            {id: ci.id, product_id: ci.product.id, adjustment: 14},
            {id: ci2.id, product_id: ci2.product.id, adjustment: 0}
        ])
      end
    end

    context "with full_price = -1" do
      it "should not apply discount when markdown is an advantage" do
        ci =  cart_item(price: 100, retail_price: 60)
        ci2 =  cart_item(price: 100, retail_price: 90)
        ci3 =  cart_item(price: 100)
        expect(subject.calculate([ ci, ci2, ci3 ], {'param' => '50', 'full_price' => '-1'})).
          to eq([
            {id: ci.id, product_id: ci.product.id, adjustment: 12},
            {id: ci2.id, product_id: ci2.product.id, adjustment: 18},
            {id: ci3.id, product_id: ci3.product.id, adjustment: 20}
        ])
      end
    end
  end
end
