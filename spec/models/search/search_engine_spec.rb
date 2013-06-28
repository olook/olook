require 'spec_helper'

describe SearchEngine do

  subject { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }

  describe "#initialize" do
    it { expect(subject.instance_variable_get("@search")).to_not be_nil }
  end

  describe "#for_page" do
    context "when page is nil" do
      it "sets current page as 1" do
        subject.for_page(nil)
        expect(subject.instance_variable_get("@current_page")).to eq(1)
      end
    end

    context "when page was passed" do
      it "sets current page as passed value" do
        subject.for_page("3")
        expect(subject.instance_variable_get("@current_page")).to eq(3)
      end
    end
  end

  describe "#next_page" do
    before do
      subject.stub(:current_page).and_return(10)
    end
    it "returns current_page + 1" do
      expect(subject.next_page).to eq(11)
    end
  end

  describe "#previous_page" do
    before do
      subject.instance_variable_set("@current_page", 10)
    end
    it "returns current_page - 1" do
      expect(subject.previous_page).to eq(9)
    end
  end

  describe "#with_limit" do
    context "when limit was passed" do
      it "sets limit as given parameter" do
        subject.with_limit("100")
        expect(subject.instance_variable_get("@limit")).to eq(100)
      end
    end

    context "when limit wasn't passed" do
      it "sets limit as 50 (default)" do
        subject.with_limit
        expect(subject.instance_variable_get("@limit")).to eq(50)
      end
    end
  end

  describe "#start_product" do
    context "when there's limit" do
      before do
        subject.instance_variable_set("@current_page", 5)
        subject.instance_variable_set("@limit", 50)
      end

      it { expect(subject.start_product).to eq(200) }
    end

    context "when there's no limit" do
      before do
        subject.stub(:limit).and_return(nil)
      end

      it { expect(subject.start_product).to eq(0) }
    end
  end

  describe "#products" do
    before do
      subject.instance_variable_set("@limit", 50)
    end

    it "SearchEngine#search receives Search#build_url_for" do
      subject.should_receive(:fetch_result).with(nil, {parse_products: true}).and_return(OpenStruct.new(products:nil))
      subject.should_receive(:build_url_for).with(limit: 50, start: subject.start_product)
      subject.products
    end
  end

  describe "#filters" do
    before do
      subject.instance_variable_set("@limit", 50)
    end

    it "SearchEngine#search receives Search#build_filters" do
      subject.should_receive(:fetch_result).and_return(OpenStruct.new(facets:nil))
      subject.should_receive(:build_filters_url)
      subject.filters
    end
  end

  describe "#filters" do
    pending
  end

  describe "#has_next_page?" do
    let(:search) { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }
    context "when current page is lower than pages" do

      before do
        search.stub(:current_page).and_return(1)
        search.stub(:pages).and_return(10)
      end

      subject { search.has_next_page? }

      it { should be_true }
    end
    context "when current page is eq than pages" do
      before do
        search.stub(:current_page).and_return(10)
        search.stub(:pages).and_return(10)
      end

      subject { search.has_next_page? }

      it { should be_false }
    end

    context "when current page is greater than pages" do
      before do
        search.stub(:current_page).and_return(11)
        search.stub(:pages).and_return(10)
      end

      subject { search.has_next_page? }

      it { should be_false }
    end
  end

  describe "#has_previous_page?" do
    let(:search) { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }
    context "when current page is lower than 1" do
      before do
        search.stub(:current_page).and_return(0)
      end

      subject { search.has_previous_page? }

      it { should be_false }
    end
    context "when current page is eq than 1" do
      before do
        search.stub(:current_page).and_return(1)
      end

      subject { search.has_previous_page? }

      it { should be_false }
    end

    context "when current page is greater than 1" do
      before do
        search.stub(:current_page).and_return(11)
      end

      subject { search.has_previous_page? }

      it { should be_true }
    end
  end

  describe "#selected_filters_for" do
    it "delegates to @search#expressions" do
      subject.instance_variable_get("@search").should_receive(:expressions).and_return(Hash.new)
      subject.selected_filters_for("filter")
    end
  end

  describe "#has_any_filter_selected?" do
    let(:search) { described_class.new }
    context "when all filters was selected" do
      before do
        search.instance_variable_get("@search")
        .should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: ["bar"], color: ["foo"], heel: ["foo"], care: ["bar"] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_true }
    end

    context "when one filter was selected" do
      before do
        search.instance_variable_get("@search")
        .should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: ["bar"], color: [], heel: [], care: [] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_true }
    end

    context "when all filters wasn't selected" do
      before do
        search.instance_variable_get("@search")
        .should_receive(:expressions)
        .and_return({ category: ["sapato"], subcategory: [], color: [], heel: [], care: [] })
      end
      subject { search.has_any_filter_selected? }
      it { should be_false }
    end
  end

  describe "#current_page_greater_than_limit_link_pages?" do
    let(:search) { described_class.new }
    context "when current_page is greater than 4" do
      before do
        search.stub(:current_page).and_return(5)
      end
      subject { search.current_page_greater_than_limit_link_pages? }
      it { should be_true }
    end

    context "when current_page is eq than 4" do
      before do
        search.stub(:current_page).and_return(4)
      end
      subject { search.current_page_greater_than_limit_link_pages? }
      it { should be_false }
    end

    context "when current_page is lower than 4" do
      before do
        search.stub(:current_page).and_return(3)
      end
      subject { search.current_page_greater_than_limit_link_pages? }
      it { should be_false }
    end
  end

  describe "#current_page_greater_or_eq_than_limit_link_pages?" do
    let(:search) { described_class.new }
    context "when current_page is greater than 4" do
      before do
        search.stub(:current_page).and_return(5)
      end
      subject { search.current_page_greater_or_eq_than_limit_link_pages? }
      it { should be_true }
    end

    context "when current_page is eq than 4" do
      before do
        search.stub(:current_page).and_return(4)
      end
      subject { search.current_page_greater_or_eq_than_limit_link_pages? }
      it { should be_true }
    end

    context "when current_page is lower than 4" do
      before do
        search.stub(:current_page).and_return(3)
      end
      subject { search.current_page_greater_or_eq_than_limit_link_pages? }
      it { should be_false }
    end
  end

  describe "#last_three_pages" do
    let(:search) { described_class.new }
    before do
      search.stub(:current_page).and_return(4)
    end

    subject { search.last_three_pages }

    it { should eq(1) }
  end

  describe "#next_three_pages" do
    let(:search) { described_class.new }
    before do
      search.stub(:current_page).and_return(4)
    end

    subject { search.next_three_pages }

    it { should eq(7) }
  end

  describe "#has_at_least_three_more_pages?" do
    let(:search) { described_class.new }
    context "when search has at least more than 3 pages ahead" do
      before do
        search.stub(:current_page).and_return(4)
        search.stub(:pages).and_return(8)
      end

      subject { search.has_at_least_three_more_pages? }

      it { should be_true }
    end
    context "when search has only 3 pages ahead" do
      before do
        search.stub(:current_page).and_return(4)
        search.stub(:pages).and_return(7)
      end

      subject { search.has_at_least_three_more_pages? }

      it { should be_false }
    end
    context "when search has no 3 pages ahead" do
      before do
        search.stub(:current_page).and_return(4)
        search.stub(:pages).and_return(5)
      end

      subject { search.has_at_least_three_more_pages? }

      it { should be_false }
    end
  end

end
