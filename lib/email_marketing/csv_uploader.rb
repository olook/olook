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

    attr_reader :csv

    def initialize
      @csv = ""
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

    def generate_email_csv(data)
      CSV.generate do |row|
        row << ["email"]
        data.each { |item| row << [item["email"]] }
      end
    end

  end
end