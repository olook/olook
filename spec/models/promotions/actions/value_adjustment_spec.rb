# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ValueAdjustment do
  describe "calculate" do
     it "has adjustments" do
       cart_item = double('cart_item')
       cart_item.stub(id: 7, product: stub(id: 77))

       subject.calculate([ cart_item ], {'param' => "20"}).should eq([{id: 7, product_id: 77, adjustment: 20}])
     end
  end
end
