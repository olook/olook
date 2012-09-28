# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe MarketingReports::FileUploader do
  let(:file_content) { "This is an Example String" }

  subject { described_class.new(file_content) }

  describe "#save_to_disk" do
    let(:file) { double(:file, :path => "tmp/temp_name.csv", :write => "") }

    context "creating the file" do
      it "creates a new temporary file in the tmp dir" do
        file.stub(:write)
        Tempfile.should_receive(:open).with('/tmp/', 'w', :encoding => "ISO-8859-1").and_yield(file)
        subject.save_to_disk
      end

      it "writes the received string to the tempfile" do
        Tempfile.stub(:open).and_yield(file)
        file.should_receive(:write).with(file_content)
        subject.save_to_disk
      end
    end

    context "copying the file" do
      let(:filename) { "file.csv" }

      it "uses untitled.txt as filename when no name is passed" do
        FileUtils.should_receive(:copy).with(anything, "/home/allinmail/untitled.txt")
        subject.save_to_disk
      end

      it "uses received name as filename" do
        FileUtils.should_receive(:copy).with(anything, "/home/allinmail/#{filename}")
        subject.save_to_disk(filename)
      end

      it "puts the created temp file in the network directory" do
        Tempfile.stub(:open).and_yield(file)
        FileUtils.should_receive(:copy).with(file.path, "/home/allinmail/#{filename}").at_most(:once)
        subject.save_to_disk(filename)
      end
    end
  end
end
