require 'spec_helper'

describe SearchEngine do

  subject { described_class.new(category: "SomeCategory", subcategory: "SomeSubcategory", color: "SomeColor") }

  describe "#initialize" do
    it { expect(subject.search).to_not be_nil }
  end

  describe "#for_page" do
    context "when page is nil" do
      it "sets current page as 1" do
        subject.for_page(nil)
        expect(subject.current_page).to eq(1)
      end
    end

    context "when page was passed" do
      it "sets current page as passed value" do
        subject.for_page("3")
        expect(subject.current_page).to eq(3)
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
      subject.stub(:current_page).and_return(10)
    end
    it "returns current_page - 1" do
      expect(subject.previous_page).to eq(9)
    end
  end

  describe "#with_limit" do
    context "when limit was passed" do
      it "sets limit as given parameter" do
        subject.with_limit("100")
        expect(subject.limit).to eq(100)
      end
    end

    context "when limit wasn't passed" do
      it "sets limit as 50 (default)" do
        subject.with_limit
        expect(subject.limit).to eq(50)
      end
    end
  end

  describe "#start_product" do
    before do
      subject.stub(:current_page).and_return(5)
      subject.stub(:limit).and_return(50)
    end

    it { expect(subject.start_product).to eq(200) }
  end

  describe "#url" do
    it "SearchEngine#search receives Search#build_url_for" do
      subject.search.should_receive(:build_url_for).with(subject)
      subject.url
    end
  end

  describe "#filters_url" do
    it "SearchEngine#search receives Search#build_filters_url" do
      subject.search.should_receive(:build_filters_url)
      subject.filters_url
    end
  end

  describe "#filters" do
    pending
  end

  describe "#products" do
    pending
  end

end
