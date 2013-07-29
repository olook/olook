require File.expand_path( File.join( File.dirname(__FILE__), '../../../lib/search/paginable' ) )

describe Search::Paginable do
  before do
    class Dummy
      include Search::Paginable
      def total_results
        100
      end
    end
  end

  subject { Dummy.new }

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

  describe "#start_item" do
    context "when there's limit" do
      before do
        subject.instance_variable_set("@current_page", 5)
        subject.instance_variable_set("@limit", 50)
      end

      it { expect(subject.start_item).to eq(200) }
    end

    context "when there's no limit" do
      before do
        subject.instance_variable_set("@limit", nil)
      end

      it { expect(subject.start_item).to eq(0) }
    end
  end

  describe "#next_page" do
    before do
      subject.instance_variable_set('@current_page', 10)
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
        subject.with_limit(100)
        expect(subject.instance_variable_get("@limit")).to eq(100)
      end
    end

    context "when given limit is nil" do
      it "sets limit as 30 (default)" do
        subject.with_limit nil
        expect(subject.instance_variable_get("@limit")).to eq(30)
      end
    end
  end

  describe "#has_next_page?" do
    context "when current page is lower than pages" do

      before do
        subject.instance_variable_set('@current_page', 1)
        subject.stub(:pages).and_return(10)
      end

      it { expect( subject.has_next_page? ).to be_true }
    end
    context "when current page is eq than pages" do
      before do
        subject.instance_variable_set('@current_page', 10)
        subject.stub(:pages).and_return(10)
      end

      it { expect(subject.has_next_page?).to be_false }
    end

    context "when current page is greater than pages" do
      before do
        subject.instance_variable_set('@current_page', 11)
        subject.stub(:pages).and_return(10)
      end

      it { expect( subject.has_next_page? ).to be_false }
    end
  end

  describe "#has_previous_page?" do
    context "when current page is lower than 1" do
      before do
        subject.instance_variable_set('@current_page', 0)
      end

      it { expect(subject.has_previous_page?).to be_false }
    end
    context "when current page is eq than 1" do
      before do
        subject.instance_variable_set('@current_page', 1)
      end

      it { expect(subject.has_previous_page?).to be_false }
    end

    context "when current page is greater than 1" do
      before do
        subject.instance_variable_set('@current_page', 11)
      end

      it { expect(subject.has_previous_page?).to be_true }
    end
  end

  describe "#current_page_greater_than_limit_link_pages?" do
    context "when current_page is greater than 4" do
      before do
        subject.instance_variable_set('@current_page', 5)
      end
      it { expect( subject.current_page_greater_than_limit_link_pages? ).to be_true }
    end

    context "when current_page is eq than 4" do
      before do
        subject.instance_variable_set('@current_page', 4)
      end
      it { expect( subject.current_page_greater_than_limit_link_pages? ).to be_false }
    end

    context "when current_page is lower than 4" do
      before do
        subject.instance_variable_set('@current_page', 3)
      end
      it { expect( subject.current_page_greater_than_limit_link_pages? ).to be_false }
    end
  end

  describe "#current_page_greater_or_eq_than_limit_link_pages?" do
    context "when current_page is greater than 4" do
      before do
        subject.instance_variable_set('@current_page', 5)
      end
      it { expect(subject.current_page_greater_or_eq_than_limit_link_pages?).to be_true }
    end

    context "when current_page is eq than 4" do
      before do
        subject.instance_variable_set('@current_page', 4)
      end
      it { expect(subject.current_page_greater_or_eq_than_limit_link_pages?).to be_true }
    end

    context "when current_page is lower than 4" do
      before do
        subject.instance_variable_set('@current_page', 3)
      end
      it { expect(subject.current_page_greater_or_eq_than_limit_link_pages?).to be_false }
    end
  end

  describe "#last_three_pages" do
    before do
      subject.instance_variable_set('@current_page', 4)
    end

    it { expect(subject.last_three_pages).to eq(1) }
  end

  describe "#next_three_pages" do
    before do
      subject.instance_variable_set('@current_page', 4)
    end

    it { expect(subject.next_three_pages).to eq(7) }
  end

  describe "#has_at_least_three_more_pages?" do
    context "when has at least more than 3 pages ahead" do
      before do
        subject.instance_variable_set('@current_page', 4)
        subject.stub(:pages).and_return(8)
      end

      it { expect(subject.has_at_least_three_more_pages?).to be_true }
    end
    context "when has only 3 pages ahead" do
      before do
        subject.instance_variable_set('@current_page', 4)
        subject.stub(:pages).and_return(7)
      end

      it { expect(subject.has_at_least_three_more_pages?).to be_false }
    end
    context "when hasn't 3 pages ahead" do
      before do
        subject.instance_variable_set('@current_page', 4)
        subject.stub(:pages).and_return(5)
      end

      it { expect(subject.has_at_least_three_more_pages?).to be_false }
    end
  end
end
