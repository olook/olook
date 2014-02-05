# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SearchEngine do

  subject { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }

  describe "#build_filters_url" do
    context "using category" do
      before do
        @search = SearchEngine.new(category: 'sapato', subcategory: 'anabela')
      end

      it "should ignore subcategory filter" do
        expect(@search.build_filters_url(use_fields: [:category])).to_not match(/bq=[^&]*subcategory/)
      end
    end
  end

  describe "#has_any_filter_selected?" do
    let(:search) { described_class.new }
    context "when all filters was selected" do
      before do
        search.should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: ["bar"], color: ["foo"], heel: ["foo"], care: ["bar"] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_true }
    end

    context "when one filter was selected" do
      before do
        search.should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: ["bar"], color: [], heel: [], care: [] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_true }
    end

    context "when all filters wasn't selected" do
      before do
        search.should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: [], color: [], heel: [], care: [] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_false }
    end
  end

  describe "#remove_filter" do
    let(:search) { described_class.new }
    let(:expressions) { {is_visible: [1],
                         inventory: ["inventory:1.."],
                         category: ["Some Category"],
                         subcategory:["Some Subcategory"],
                         color: [],
                         brand: ["Some Brand"],
                         heel: [],
                         care: [],
                         price: [],
                         size: [],
                         product_id: []} }

    let(:expected_parameters) { { category: [],
                         subcategory:[],
                         color: [],
                         brand: ["Some Brand"],
                         heel: [],
                         care: [],
                         price: [],
                         size: [],
                         product_id: []} }
    before do
      search.stub(:expressions).and_return(expressions)
    end

    context "when given parameter is a String" do
      subject { search.remove_filter "category" }

      it { should eq(expected_parameters) }
    end

    context "when given parameter is a Symbol" do
      subject { search.remove_filter :category }

      it { should eq(expected_parameters) }
    end
  end

  describe '#filters_applied' do
    it { expect(subject.filters_applied(:subcategory, "sub")).to be_a(Hash) }

    context "adding a new value for a given key" do
      let(:search) { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }
      subject { search.filters_applied(:subcategory, "Other_Sub") }

      it { expect(subject[:category]).to eq(['somecategory']) }
      it { expect(subject[:subcategory]).to eq(['somesubcategory', 'other_sub']) }
      it { expect(subject[:color]).to eq(['somecolor']) }

      it { expect(subject["category"]).to eq(['somecategory']) }
      it { expect(subject["subcategory"]).to eq(['somesubcategory', 'other_sub']) }
      it { expect(subject["color"]).to eq(['somecolor']) }

      context "removing filter" do

        let(:search) { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory-OtherSubcategory", color: "SomeColor") }
        subject { search.filters_applied(:subcategory, "SomeSubcategory") }

        it { expect(subject[:category]).to eq(['somecategory']) }
        it { expect(subject[:subcategory]).to eq(["othersubcategory"]) }
        it { expect(subject[:color]).to eq(['somecolor']) }

        it { expect(subject["category"]).to eq(['somecategory']) }
        it { expect(subject["subcategory"]).to eq(["othersubcategory"]) }
        it { expect(subject["color"]).to eq(['somecolor']) }

      end

      context "with accents" do
        subject { search.filters_applied(:subcategory, "óculos") }
        it { expect(subject[:subcategory]).to eq(['somesubcategory', 'oculos']) }
      end
    end
  end
end
