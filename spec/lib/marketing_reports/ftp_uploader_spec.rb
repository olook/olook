# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe MarketingReports::FtpUploader do
  let(:info_ftp) { "exact_target.yml" }
  let(:filename) { "SimpleName.csv" }

  subject { described_class.new(filename, info_ftp) }

  describe "#upload_to_ftp" do
    it "upload file to ftp" do
      Rails.env.stub(:production?) { true }
      Net::FTP.should_receive(:open)
      subject.upload_to_ftp
    end
  end
end
