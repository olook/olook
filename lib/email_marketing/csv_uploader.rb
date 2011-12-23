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

    FILE_PATH =  "/tmp/"

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
      ftp.passive = true
      Tempfile.open(FILE_PATH, 'w', :encoding => 'ISO-8859-1') do |file|
        file.write @csv
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

    private

    def generate_userbase
      bounced_list = generate_bounced_list
      @csv = CSV.generate do |row|
        row << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at
                   invite_token first_name last_name facebook_token birthday }
        User.find_each do |u|
          unless bounced_list.include?(u.email)
            row << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at,
                    u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday ]
          end
        end
      end
    end

    def generate_bounced_list
      responses = []
      [:invalid_emails, :spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list).parsed_response
      end
      responses.map { |item| item["email"] }
    end

    def generate_email_csv(data)
      CSV.generate do |row|
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

  end
end