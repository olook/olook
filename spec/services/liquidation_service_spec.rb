require 'spec_helper'

describe LiquidationService do
  let(:liquidation) { FactoryGirl.create(:liquidation) }

  subject do
    LiquidationService.new(liquidation.id)
  end

  def products_ids
    Product.all.map(&:id).join(",")
  end

  it "should insert the products for the liquidation" do
    3.times { FactoryGirl.create(:bag_subcategory_name) }
    expect {
      subject.add(products_ids, 30.2)
    }.to change(LiquidationProduct, :count).by(3)
    LiquidationProduct.last.subcategory_name.should == "Bolsa Azul"
  end
end
