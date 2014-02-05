require 'spec_helper'

describe ConsolidatedSell do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe 'scopes' do

    describe '.in_last_week' do
      let!(:most_recent_consolidated_sell) { FactoryGirl.create(:consolidated_sell, day: (Time.zone.today - 1.day)) }
      let!(:recent_consolidated_sell) { FactoryGirl.create(:consolidated_sell, day: (Time.zone.today - 7.days)) }
      let!(:old_consolidated_sell) { FactoryGirl.create(:consolidated_sell) }

      subject { described_class.in_last_week }

      it { should include most_recent_consolidated_sell }
      it { should include recent_consolidated_sell }
      it { should_not include old_consolidated_sell }
    end
  end

  describe '.find_or_create_consolidated_record' do
    let(:product) { FactoryGirl.create(:shoe) }
    context "when there's any consolidated sell for given product" do
      before do
        product.stub(:subcategory).and_return("anabela")
      end
      let!(:consolidated_sell) { FactoryGirl.create(:consolidated_sell, product: product) }
      subject { described_class.find_or_create_consolidated_record(product, Date.new(2013, 03, 22)) }
      it { should eq consolidated_sell }
    end

    context "when there's no any consolidated sell with given product" do
      it {
        expect{described_class.find_or_create_consolidated_record(product, Date.new(2013, 03, 22))}.to change{product.consolidated_sells.count}.from(0).to(1)
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
    let!(:product) { FactoryGirl.create(:shoe) }
    let(:consolidated) { FactoryGirl.create(:consolidated_sell) }
    before do
      described_class.stub(:find_or_create_consolidated_record).and_return(consolidated)
      product.stub(:price).and_return(BigDecimal("10,00"))
      product.stub(:retail_price).and_return(BigDecimal("10,00"))
    end

    context "summarizing" do
      context "saving" do
        it "saves consolidate" do
          consolidated.should_receive(:save!)
          described_class.summarize(date, product, amount)
        end
      end

      context "incrementing consolidated attributes" do
        it "increments amount" do
          described_class.summarize(date, product, amount)
          expect(consolidated.amount).to eq(11)
        end

        it "increments total" do
          described_class.summarize(date, product, amount)
          expect(consolidated.total.to_s).to eq("109.99")
        end

        it "increments total retail" do
          described_class.summarize(date, product, amount)
          expect(consolidated.total_retail).to eq(BigDecimal "109.99")
        end
      end
    end

    context "getting consolidated sell" do

      it "searches or creates consolidated sell with given product and day" do
        described_class.should_receive(:find_or_create_consolidated_record).with(product, date).and_return(consolidated)
        described_class.summarize(date, product, amount)
      end

    end


  end
end
