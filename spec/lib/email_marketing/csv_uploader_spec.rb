# -*- encoding : utf-8 -*-

require 'spec_helper'

describe EmailMarketing::CsvUploader do
  let(:user_a) { FactoryGirl.create :user }
  let(:user_b) { FactoryGirl.create :user }
  let(:user_c) { FactoryGirl.create :user }
  let(:response) { double(:response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"teste@teste.com"} ]) }
  let(:services) do
    {
      :spam_reports   => double(:s_response, :parsed_response => [ {"reason"=>"Any", "email"=> "a@b.com"} ]),
      :unsubscribes   => double(:u_response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"g@h.com"} ]),
      :blocks         => double(:b_response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"e@f.com"} ]),
      :invalid_emails => double(:i_response, :parsed_response => [ {"reason"=>"500", "email"=>"c@d.com"} ]),
    }
  end

  describe "#initialize" do
    context "when no type is passed" do
      it "sets csv to empty string" do
        subject.csv.should == ""
      end
    end

    describe "when type is invalid" do
      it "calls sendgrid invalid emails service" do
        EmailMarketing::SendgridClient.should_receive(:new).with(:invalid_emails).and_return(mock.as_null_object)

        EmailMarketing::CsvUploader.new(:invalid)
      end

      it "builds a csv file with invalid emails" do
        EmailMarketing::SendgridClient.stub(:new).with(:invalid_emails).and_return(services[:invalid_emails])

        EmailMarketing::CsvUploader.new(:invalid).csv.should == "c@d.com\n"
      end
    end

    describe "when type is optout" do
      let(:optout_services) { [:spam_reports, :unsubscribes, :blocks] }

      it "calls sendgrid spam_reports, unsubscribes and blocks services" do
        optout_services.each { |name| EmailMarketing::SendgridClient.should_receive(:new).with(name).and_return(services[name]) }

        EmailMarketing::CsvUploader.new(:optout)
      end

      it "builds a csv file with emails from spam_reports, unsubscribes and blocks" do
        optout_services.each { |name| EmailMarketing::SendgridClient.stub(:new).with(name).and_return(services[name]) }

        EmailMarketing::CsvUploader.new(:optout).csv.should == "a@b.com\ng@h.com\ne@f.com\n"
      end
    end

    context "when type is userbase" do
      let(:csv_header) do
        "id,email,created_at,sign_in_count,current_sign_in_at,last_sign_in_at,invite_token,first_name,last_name,facebook_token,birthday\n"
      end

      it "builds a csv file containing all user data" do
        services.each { |service, response| EmailMarketing::SendgridClient.stub(:new).with(service).and_return(response) }

        csv_body = [user_a, user_b, user_c].inject("") do |data, user|
          data += "#{user.id},#{user.email},#{user.created_at},#{user.sign_in_count},#{user.current_sign_in_at},#{user.last_sign_in_at},#{user.invite_token},#{user.first_name},#{user.last_name},#{user.facebook_token},#{user.birthday}\n"
          data
        end

        EmailMarketing::CsvUploader.new(:userbase).csv.should == csv_header + csv_body
      end

      it "does not include a user which email was included in any bounced list (spam reports, unsubscribers, blocks or invalid)" do

        services = {
          :spam_reports   => double(:s_response, :parsed_response => [ {"reason" => "Any", "email" => user_a.email } ]),
          :unsubscribes   => double(:u_response, :parsed_response => [ {"reason" => "Unknown", "email" => user_b.email } ]),
          :blocks         => double(:b_response, :parsed_response => [ {"reason" => "Unknown", "email" => user_c.email } ]),
          :invalid_emails => double(:i_response, :parsed_response => [ {"reason" => "500", "email" => user_c.email } ])
        }

        services.each { |service, response| EmailMarketing::SendgridClient.stub(:new).with(service).and_return(response) }

        EmailMarketing::CsvUploader.new(:userbase).csv.should == csv_header
      end
    end
  end

  describe "#copy_to_ftp" do
    before do
      EmailMarketing::CsvUploader.class_eval { remove_const :FTP_SERVER }
      EmailMarketing::CsvUploader::FTP_SERVER = {
        :host => "ftp.host.com",
        :username => "username",
        :password => "password"
      }
    end

    let(:connection) { mock(:ftp_connection) }

    it "opens new ftp connection using configuration from EmailMarketing::CsvUploader::FTP_SERVER" do
      Net::FTP.should_receive(:new).with("ftp.host.com","username", "password").and_return(mock.as_null_object)
      subject.copy_to_ftp(anything)
    end

    context "copying the file" do
      before do
        Net::FTP.stub(:new).and_return(connection)
        connection.stub(:close)
        connection.stub(:passive=)
      end

      it "uses untitled.txt as filename when no name is passed" do
        connection.should_receive(:puttextfile).with(anything, "untitled.txt")
        subject.copy_to_ftp
      end

      it "uses received name as filename" do
        filename = "file.csv"
        connection.should_receive(:puttextfile).with(anything, filename)
        subject.copy_to_ftp(filename)
      end
    end

    it "sets connection to passive mode" do
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:close)
      connection.stub(:puttextfile)

      connection.should_receive(:passive=).with(true)
      subject.copy_to_ftp
    end

    it "closes the ftp connection" do
      Net::FTP.stub(:new).and_return(connection)
      connection.stub(:puttextfile)
      connection.stub(:passive=)

      connection.should_receive(:close)
      subject.copy_to_ftp
    end
  end
end