require 'spec_helper'
describe ProductObserver do

  let(:product) { FactoryGirl.create(:shoe) }
  let!(:old_price) { product.price }
  let!(:old_retail_price) { product.retail_price }
  let(:new_value) { BigDecimal "99" }

  context "when changing product price" do
    it { expect{product.update_attributes(price: new_value)}.to change{product.price_logs.count}.from(0).to(2) }
    context "price logs data" do
      before do
        product.update_attributes(price: new_value)
      end
      it { expect(product.price_logs.first.price).to eq(0) }
    end
  end

  context "when changing product retail price" do
    it { expect{product.update_attributes(price: new_value)}.to change{product.price_logs.count}.from(0).to(2) }
    context "price logs data" do
      before do
        product.master_variant.stub(:retail_price_was).and_return(old_retail_price)
        product.update_attributes(retail_price: new_value)
      end
      it { expect(product.price_logs.first.retail_price).to eq(old_retail_price) }
    end
  end

  context "when not changing product price or retail price" do
    it { expect{product.update_attributes(name: 'new name')}.to_not change{product.price_logs.count}.from(0).to(1) }
  end
end
