# -*- encoding : utf-8 -*-

require 'spec_helper'

describe EmailMarketing::CsvUploader do

  describe "#initialize" do
    context "when type is invalid" do

    end

    it "sets csv to empty string" do
      subject.csv.should == ""
    end
  end

  describe "#generate_invalid" do
    it "calls sendgrid invalid emails service" do
      EmailMarketing::SendgridClient.should_receive(:new).with(:invalid_emails).and_return(mock.as_null_object)

      subject.generate_invalid
    end

    it "builds a csv file with invalid emails" do
      response_hash = [
                        {"reason"=>"Known bad domain", "email"=>"niceivanice@homail.com"},
                        {"reason"=>"Known bad domain", "email"=>"william_fi_ude@hotmai.com"}
                      ]

      response = double(:response, :parsed_response => response_hash)
      EmailMarketing::SendgridClient.stub(:new).with(:invalid_emails).and_return(response)

      subject.generate_invalid.should == "email\nniceivanice@homail.com\nwilliam_fi_ude@hotmai.com\n"
    end
  end

  describe "#generate_optout" do

    it "calls sendgrid spam_reports, unsubscribes and blocks services" do
      response = double(:response, :parsed_response => [{"email"=>"teste@teste.com"}])

      EmailMarketing::SendgridClient.should_receive(:new).with(:spam_reports).and_return(response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:unsubscribes).and_return(response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:blocks).and_return(response)

      subject.generate_optout
    end

    it "builds a csv file with emails from spam_reports, unsubscribes and blocks" do
      spam = [ {"reason"=>"Known bad domain", "email"=>"niceivanice@homail.com"} ]
      unsubscribes =  [ {"reason"=>"500", "email"=>"william_fi_ude@yahoo.com"} ]
      blocks =  [ {"reason"=>"Unknown", "email"=>"rinaldi.fonseca@gmail.com"} ]

      spam_response = double(:response, :parsed_response => spam)
      unsubscribes_response = double(:response, :parsed_response => unsubscribes)
      blocks_reponse = double(:response, :parsed_response => blocks)

      EmailMarketing::SendgridClient.stub(:new).with(:spam_reports).and_return(spam_response)
      EmailMarketing::SendgridClient.stub(:new).with(:unsubscribes).and_return(unsubscribes_response)
      EmailMarketing::SendgridClient.stub(:new).with(:blocks).and_return(blocks_reponse)

      subject.generate_optout.should == "email\nniceivanice@homail.com\nwilliam_fi_ude@yahoo.com\nrinaldi.fonseca@gmail.com\n"
    end
  end


  describe "#copy_to_ftp" do
    let(:connection) { mock(:ftp_connection) }

    it "opens new ftp connection using ftp server config" do
      Net::FTP.should_receive(:new).with(EmailMarketing::CsvUploader::FTP_SERVER[:host],
                                         EmailMarketing::CsvUploader::FTP_SERVER[:username],
                                         EmailMarketing::CsvUploader::FTP_SERVER[:password]).and_return(mock.as_null_object)
      subject.copy_to_ftp(anything)
    end

    context "setting file name" do
      it "uses emails.csv as filename when no name is passed" do
        filename = "file.csv"
        Net::FTP.stub(:new).and_return(connection)
        connection.stub(:close)

        connection.should_receive(:puttextfile).with(anything, "emails.csv")
        subject.copy_to_ftp
      end

      it "uses received name as filename" do
        filename = "file.csv"
        Net::FTP.stub(:new).and_return(connection)
        connection.stub(:close)

        connection.should_receive(:puttextfile).with(anything, filename)
        subject.copy_to_ftp(filename)
      end
    end

    it "copies the ftp " do

    end

    it "closes the ftp connection" do
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:puttextfile)

      connection.should_receive(:close)
      subject.copy_to_ftp(anything)
    end
  end
end