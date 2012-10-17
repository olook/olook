# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe MarketingReports::FileUploader do
  let(:file_content) { "This is an Example String" }
  let(:info_ftp) { "exact_target.yml" }
  let(:filename) { "SimpleName" }

  subject { described_class.new(file_content) }

  after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/SimpleName"])
  end

  describe "#save_to_disk" do
    let(:file) { double(:file, :path => "#{Rails.root}/tmp/temp_name.csv", :write => "") }

    context "creating the file" do
      it "creates a new temporary file in the tmp dir" do
        file.stub(:write)
        File.should_receive(:open).with("#{Rails.root}/tmp/untitled.txt", 'w', :encoding => "ISO-8859-1").and_yield(file)
        subject.save_to_disk
      end

      it "writes the received string to the tempfile" do
        File.stub(:open).and_yield(file)
        file.should_receive(:write).with(file_content)
        subject.save_to_disk
      end

      it "uploading file to ftp" do
        subject.should_receive(:upload_to_ftp)
        subject.save_to_disk(filename, info_ftp)
      end
    end

    context "copying the file" do
      let(:filename) { "file.csv" }
      let(:report_path) { Rails.root }
      let(:temp_path) { "#{Rails.root}/tmp/" }

      it "uses untitled.txt as filename when no name is passed" do
        FileUtils.should_receive(:copy).with(anything, "#{report_path}/untitled.txt")
        subject.save_to_disk
      end

      it "uses received name as filename" do
        FileUtils.should_receive(:copy).with(anything, "#{report_path}/#{filename}")
        subject.save_to_disk(filename)
      end

      it "puts the created temp file in the network directory" do
        Tempfile.stub(:open).and_yield(file)
        FileUtils.should_receive(:copy).with(temp_path+filename, "#{report_path}/#{filename}").at_most(:once)
        subject.save_to_disk(filename)
      end
    end
  end
end
