require 'spec_helper'

describe Abacos::IntegrateProductsObserver do
  describe '.products_to_be_integrated' do
    it "sets how many products will be integrated" do
      REDIS.should_receive(:incrby).with("products_to_integrate",10)
      described_class.products_to_be_integrated(10)
    end
  end

  describe '.decrement_products_to_be_integrated!' do
    it "decrements one product that had the integration product done" do
      REDIS.should_receive(:decrby).with("products_to_integrate", 1)
      described_class.decrement_products_to_be_integrated!
    end
  end
end
