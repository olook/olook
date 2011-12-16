# -*- encoding : utf-8 -*-

require 'spec_helper'

describe Sendgrid::EmailListUploader do

  describe "#initialize" do
    it "sets csv to empty string" do
      subject.csv.should == ""
    end
  end

  describe "#generate_invalid_emails_csv" do
    it "calls invalid emails service" do
      Sendgrid::Client.should_receive(:new).with(:invalid_emails).and_return(mock.as_null_object)

      subject.generate_invalid_emails_csv
    end

    it "returns csv file with invalid emails" do
      response_hash = [
                        {"reason"=>"Known bad domain", "email"=>"niceivanice@homail.com"},
                        {"reason"=>"Known bad domain", "email"=>"william_fi_ude@hotmai.com"}
                      ]

      response = double(:response, :parsed_response => response_hash)
      Sendgrid::Client.stub(:new).with(:invalid_emails).and_return(response)

      subject.generate_invalid_emails_csv.should == "email\nniceivanice@homail.com\nwilliam_fi_ude@hotmai.com\n"
    end
  end

  describe "#copy_to_ftp" do
    let(:connection) { mock(:ftp_connection) }

    it "opens new ftp connection using ftp server config" do
      Net::FTP.should_receive(:new).with(Sendgrid::EmailListUploader::FTP_SERVER[:host],
                                         Sendgrid::EmailListUploader::FTP_SERVER[:username],
                                         Sendgrid::EmailListUploader::FTP_SERVER[:password]).and_return(mock.as_null_object)
      subject.copy_to_ftp(anything)
    end

    it "copies the file with the received filename" do
      filename = "file.csv"
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:close)

      connection.should_receive(:puttextfile).with(anything, filename)
      subject.copy_to_ftp(filename)
    end

    it "closes the ftp connection" do
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:puttextfile)

      connection.should_receive(:close)
      subject.copy_to_ftp(anything)
    end
  end
end