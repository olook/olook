# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe MarketingReports::FileUploader do
  let(:file_content) { "This is an Example String" }
  let(:filename) { "SimpleName" }

  subject { described_class.new(file_content) }

  after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/SimpleName"])
  end

  let(:file) { double(:file, :path => "#{Rails.root}/tmp/temp_name.csv", :write => "") }

  describe "#save_local_file" do
      it "writes the received string to the tempfile" do
        File.stub(:open).and_yield(file)
        file.should_receive(:write).with(file_content)
        subject.save_local_file
      end
  end

  describe "#copy_file" do
    context "creating and copying the file" do
      it "copy the file to root path" do
        file.stub(:write)
        FileUtils.should_receive(:copy).with("#{Rails.root}/tmp/untitled.txt", "#{Rails.root}/untitled.txt")
        MarketingReports::FileUploader.copy_file("untitled.txt")
      end
    end
  end
end

