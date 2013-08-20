require 'spec_helper'

describe IntegrateProductsObserver do
  describe '.start_with' do
    it "sets how many products will be integrated" do
      REDIS.should_receive(:incrby).with("products_to_integrate",10)
      described_class.start_with(10)
    end
  end
end
