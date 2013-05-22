require 'spec_helper'

describe ClearSaleReport do
  let(:start_date) { Date.yesterday.strftime }
  let(:end_date) { Date.today.strftime }
  subject { described_class.new(start_date, end_date) }
  describe "#schedule_generation" do
    let(:parsed_start_date) { Date.parse start_date }
    let(:parsed_end_date) { Date.parse end_date }
    it "enqueues report generation" do
      Resque.should_receive(:enqueue_at).with(10.seconds, ClearSaleReportWorker, parsed_start_date, parsed_end_date)
      subject.schedule_generation
    end
  end
end
