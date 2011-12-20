# -*- encoding : utf-8 -*-
require 'net/ftp'
require 'tempfile'

module EmailMarketing
  class CsvUploader
    FTP_SERVER = {
      :host => "hftp.olook.com.br",
      :username => "allinmail",
      :password => "allinmail123abc"
    }

    FILE_PATH =  Rails.root.to_s + "/public"

    ACTIONS = [:invalid, :optout, :userbase]

    attr_reader :csv

    def initialize(type = nil)
      if ACTIONS.include? type
        self.send("generate_#{type}")
      else
        @csv = ""
      end
    end

    def copy_to_ftp(filename = nil)
      filename ||= "emails.csv"
      ftp = Net::FTP.new(FTP_SERVER[:host], FTP_SERVER[:username], FTP_SERVER[:password])
      Tempfile.open(FILE_PATH, 'w') do |file|
        file.write @csv
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

    private

    def generate_userbase
      @csv = CSV.generate do |row|
        row << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at
                   invite_token first_name last_name facebook_token birthday }
        User.find_each do |u|
          row << [ u.id, u.email, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at,
                  u.invite_token, delete_csv_fields(u.first_name), delete_csv_fields(u.last_name), u.facebook_token, u.birthday ]
        end
      end
    end

    def generate_email_csv(data)
      CSV.generate do |row|
        row << ["email"]
        data.each { |item| row << [item["email"]] }
      end
    end

    def generate_invalid
      @csv = generate_email_csv(SendgridClient.new(:invalid_emails).parsed_response)
    end

    def generate_optout
      responses = []
      [:spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list).parsed_response
      end
      @csv = generate_email_csv(responses)
    end

    def delete_csv_fields(string)
      string.delete(";,'\"")
    end

  end
end