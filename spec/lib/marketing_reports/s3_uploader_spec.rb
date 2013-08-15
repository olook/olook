# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe MarketingReports::S3Uploader do
  let(:file_content) { "This is an Example String" }

  subject { described_class.new(file_content) }

  let(:file) { double(:file, :path => "#{Rails.root}/tmp/untitled.txt", :write => "") }
  let(:connection) {Fog::Storage.new provider: 'AWS'}

  describe "#copy_file" do
    context "copying the file" do
      it "copies the file to S3" do
        filename = "untitled.txt"
        File.should_receive(:open).with(MarketingReports::S3Uploader::TEMP_PATH+DateTime.now.strftime(filename))
        MarketingReports::S3Uploader.new.copy_file(filename)
        connection.directories.get("olook-ftp-dev").files.first.key.should eq("allin/untitled.txt")
      end
    end
  end
end

