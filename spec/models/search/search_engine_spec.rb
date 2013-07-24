require 'spec_helper'

describe SearchEngine do

  subject { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }

  describe "#products" do
    before do
      subject.instance_variable_set("@limit", 50)
    end

    it "SearchEngine#search receives Search#build_url_for" do
      subject.should_receive(:fetch_result).with(nil, {parse_products: true}).and_return(OpenStruct.new(products:nil))
      subject.should_receive(:build_url_for).with(limit: 50, start: subject.start_item)
      subject.products
    end
  end

  describe "#filters" do
    pending "Most of the logic was extracted to build_filters_url, but this need some test too"
  end

  describe "#selected_filters_for" do
    it "delegates to @search#expressions" do
      subject.should_receive(:expressions).and_return(Hash.new)
      subject.selected_filters_for("filter")
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
                         subcategory:["Some Subcategory"],
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

end
