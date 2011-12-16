# -*- encoding : utf-8 -*-
require 'net/ftp'
require 'tempfile'

module Sendgrid
  class EmailListUploader
    FTP_SERVER = {
      :host => "hftp.olook.com.br",
      :username => "allinmail",
      :password => "allinmail123abc"
    }
    FILE_PATH =  Rails.root.to_s + "public"

    attr_reader :csv

    def initialize
      @csv = ""
    end

    def generate_invalid_emails_csv
      response = Sendgrid::Client.new(:invalid_emails).parsed_response

      @csv = CSV.generate do |row|
        row << ["email"]
        response.each { |item| row << [item["email"]] }
      end
    end


    def copy_to_ftp(filename,dir = nil)
      ftp = Net::FTP.new(FTP_SERVER[:host], FTP_SERVER[:username], FTP_SERVER[:password])
      Tempfile.open(FILE_PATH, 'w') do |file|
        file.write @csv
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

  end
end