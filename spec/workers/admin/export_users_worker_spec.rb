# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admin::ExportUsersWorker do
  describe '#perform' do
    let(:email) { "user@example.com" }

    it "should call UserReport#generate_csv to create the CSV file" do
      UserReport.should_receive(:generate_csv)

      Admin::ExportUsersWorker.perform(email)
    end

    it "should call Admin::UserExportMailer.csv_ready with the received email" do
      Admin::UserExportMailer.should_receive(:csv_ready).with(email).and_return(mock.as_null_object)
      Admin::ExportUsersWorker.perform(email)
    end
  end
end
