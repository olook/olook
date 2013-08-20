# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Abacos::IntegrateProductsObserver do
  describe '.products_to_be_integrated' do
    it "sets how many products will be integrated" do
      REDIS.should_receive(:incrby).with("products_to_integrate",10)
      described_class.products_to_be_integrated(10)
    end
  end

  describe '.mark_product_integrated_as_success!' do
    it "decrements one product that had the integration product done" do
      REDIS.should_receive(:decrby).with("products_to_integrate", 1)
      described_class.mark_product_integrated_as_success!
    end
  end

  describe '.mark_product_integrated_as_failure!' do
    it "decrements one product that had the integration product done" do
      REDIS.should_receive(:decrby).with("products_to_integrate", 1)
      described_class.mark_product_integrated_as_failure!
    end
  end

  describe '.perform' do
    let(:opts) { {
        to: 'bob@dylan.com',
        subject: 'Sincronização de produtos concluída',
        body: "Quantidade de produtos integrados: 10"
    } }

    context "when integration is finished" do
      before do
        REDIS.stub(:get).and_return("0")
      end
      it "sends alert notification" do
        Resque.should_receive(:enqueue).with(NotificationWorker, opts)
        described_class.perform(opts)
      end
    end

    context "when integration is not finished" do
      before do
        REDIS.stub(:get).and_return("1")
      end

      it "enqueues verification from now to 5 minutes" do
        Resque.should_receive(:enqueue_in).with(5.minutes, described_class, opts)
        described_class.perform(opts)
      end
    end
  end
end
