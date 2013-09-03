require 'spec_helper'

describe ConsolidatedSell do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe '.get_consolidated_record' do
    context "when there's any consolidated sell with given data" do
      let!(:consolidated_sell) { FactoryGirl.create(:consolidated_sell) }
      subject { described_class.get_consolidated_record(1, "anabela", Date.new(2013, 03, 22)) }
      it { should eq consolidated_sell }
    end

    context "when there's no any consolidated sell with given data" do
      it {
        expect{described_class.get_consolidated_record("1", "anabela", Date.new(2013, 03, 22))}.to change{described_class.count}.from(0).to(1)
      }
    end
  end

  describe '.summarized_report_for' do
    let(:date) { Date.new(2013, 9, 03) }
    let(:mock_response) { mock(Object) }

    context "searching" do
      before do
        mock_response.stub(:order)
      end
      it "searches by day" do
        described_class.should_receive(:where).with({ day: date }).and_return(mock_response)
        described_class.summarized_report_for date
      end
    end

    context "ordering" do
      before do
        described_class.stub(:where).and_return(mock_response)
      end
      it "orders by category and subcategory" do
        mock_response.should_receive(:order).with(:category, :subcategory)
        described_class.summarized_report_for date
      end
    end
  end

  describe '.summarize' do
    let(:date) { Date.new(2013, 9, 03) }
    let(:amount) { 10 }
    let!(:variant) { FactoryGirl.create(:shoe, :in_stock).variants.first }
    let(:consolidated) { FactoryGirl.create(:consolidated_sell) }

    before do
      described_class.stub(:get_consolidated_record).and_return(consolidated)
      variant.product.stub(:price).and_return(BigDecimal("10,00"))
      variant.product.stub(:retail_price).and_return(BigDecimal("10,00"))
    end

    context "saving" do
      it "saves consolidate" do
        consolidated.should_receive(:save!)
        described_class.summarize(date, variant, amount)
      end
    end

    context "incrementing consolidated attributes" do
      it "increments amount" do
        described_class.summarize(date, variant, amount)
        expect(consolidated.amount).to eq(11)
      end

      it "increments total" do
        described_class.summarize(date, variant, amount)
        expect(consolidated.total.to_s).to eq("109.99")
      end

      it "increments total retail" do
        described_class.summarize(date, variant, amount)
        expect(consolidated.total_retail).to eq(BigDecimal "109.99")
      end

    end


  end
end
