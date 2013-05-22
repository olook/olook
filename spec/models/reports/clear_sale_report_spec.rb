require 'spec_helper'

describe ClearSaleReport do
  let(:start_date) { {"(1i)"=>"2010", "(2i)"=>"8", "(3i)"=>"16"} }
  let(:end_date) { {"(1i)"=>"2010", "(2i)"=>"8", "(3i)"=>"16"} }
  let(:admin) { mock_model Admin, email: "foo@bar.com.br" }
  subject { described_class.new(start_date, end_date, admin) }
  describe "#schedule_generation" do
    let(:parsed_start_date) { "2010-8-16" }
    let(:parsed_end_date) { "2010-8-16" }
    it "enqueues report generation" do
      Resque.should_receive(:enqueue).with(ClearSaleReportWorker, parsed_start_date, parsed_end_date, admin.email)
      subject.schedule_generation
    end
  end
end
