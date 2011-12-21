# -*- encoding : utf-8 -*-

require 'spec_helper'

describe EmailMarketing::CsvUploader do

  describe "#initialize" do
    context "when no type is passed" do
      it "sets csv to empty string" do
        subject.csv.should == ""
      end
    end
  end

  describe "when type is equal to invalid" do
    it "calls sendgrid invalid emails service" do
      EmailMarketing::SendgridClient.should_receive(:new).with(:invalid_emails).and_return(mock.as_null_object)

      EmailMarketing::CsvUploader.new(:invalid)
    end

    it "builds a csv file with invalid emails" do
      response_hash = [
                        {"reason"=>"Known bad domain", "email"=>"niceivanice@homail.com"},
                        {"reason"=>"Known bad domain", "email"=>"william_fi_ude@hotmai.com"}
                      ]

      response = double(:response, :parsed_response => response_hash)
      EmailMarketing::SendgridClient.stub(:new).with(:invalid_emails).and_return(response)

      EmailMarketing::CsvUploader.new(:invalid).csv.should == "niceivanice@homail.com\nwilliam_fi_ude@hotmai.com\n"
    end
  end

  describe "when type is equal to optout" do

    it "calls sendgrid spam_reports, unsubscribes and blocks services" do
      response = double(:response, :parsed_response => [{"email"=>"teste@teste.com"}])

      EmailMarketing::SendgridClient.should_receive(:new).with(:spam_reports).and_return(response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:unsubscribes).and_return(response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:blocks).and_return(response)

      EmailMarketing::CsvUploader.new(:optout)
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

      EmailMarketing::CsvUploader.new(:optout).csv.should == "niceivanice@homail.com\nwilliam_fi_ude@yahoo.com\nrinaldi.fonseca@gmail.com\n"
    end
  end

  context "when type is equal to userbase" do
    let(:user_a) { FactoryGirl.create :user }
    let(:user_b) { FactoryGirl.create :user }
    let(:user_c) { FactoryGirl.create(:user, :email => "a@b.com") }
    let(:response) { double(:response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"teste@teste.com"} ]) }

    it "builds a csv file containing all user data" do
      [:spam_reports, :unsubscribes, :blocks, :invalid_emails].each do |type|
        EmailMarketing::SendgridClient.stub(:new).with(type).and_return(response)
      end

      csv_header = "id,email,created_at,sign_in_count,current_sign_in_at,last_sign_in_at,invite_token,first_name,last_name,facebook_token,birthday\n"
      csv_data = [user_a, user_b, user_c].inject("") do |data,user|
        data += "#{user.id},#{user.email},#{user.created_at},#{user.sign_in_count},#{user.current_sign_in_at},#{user.last_sign_in_at},#{user.invite_token},#{user.first_name},#{user.last_name},#{user.facebook_token},#{user.birthday}\n"
        data
      end

      EmailMarketing::CsvUploader.new(:userbase).csv.should == csv_header + csv_data
    end

    it "does not include a user which email was included in any bounced list (spam reports, unsubscribers, blocks or invalid)" do
      invalids_response = double(:response, :parsed_response => [ {"reason"=>"500", "email"=>"c@d.com"} ])
      spam_response = double(:response, :parsed_response => [ {"reason"=>"Known bad domain", "email"=> user_c.email} ])
      unsubscribes_response = double(:response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"g@h.com"} ])
      blocks_reponse = double(:response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"e@f.com"} ])

      EmailMarketing::SendgridClient.should_receive(:new).with(:spam_reports).and_return(invalids_response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:unsubscribes).and_return(spam_response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:blocks).and_return(unsubscribes_response)
      EmailMarketing::SendgridClient.should_receive(:new).with(:invalid_emails).and_return(blocks_reponse)

      csv_header = "id,email,created_at,sign_in_count,current_sign_in_at,last_sign_in_at,invite_token,first_name,last_name,facebook_token,birthday\n"
      csv_data = [user_a, user_b].inject("") do |data,user|
        data += "#{user.id},#{user.email},#{user.created_at},#{user.sign_in_count},#{user.current_sign_in_at},#{user.last_sign_in_at},#{user.invite_token},#{user.first_name},#{user.last_name},#{user.facebook_token},#{user.birthday}\n"
        data
      end
      EmailMarketing::CsvUploader.new(:userbase).csv.should == csv_header + csv_data
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
        connection.stub(:passive=)

        connection.should_receive(:puttextfile).with(anything, "emails.csv")
        subject.copy_to_ftp
      end

      it "uses received name as filename" do
        filename = "file.csv"
        Net::FTP.stub(:new).and_return(connection)
        connection.stub(:close)
        connection.stub(:passive=)

        connection.should_receive(:puttextfile).with(anything, filename)
        subject.copy_to_ftp(filename)
      end
    end

    it "sets connection to passive mode" do
      filename = "file.csv"
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:close)
      connection.stub(:puttextfile)

      connection.should_receive(:passive=).with(true)
      subject.copy_to_ftp(filename)
    end

    it "closes the ftp connection" do
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:puttextfile)
      connection.stub(:passive=)

      connection.should_receive(:close)
      subject.copy_to_ftp(anything)
    end
  end
end