# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'

module MarketingReports
  class FileUploader

    FTP_SERVER = {
      :host => "hftp.olook.com.br",
      :username => "allinmail",
      :password => "allinmail123abc"
    }

    TEMP_PATH =  "/tmp/"

    def initialize(file_content)
      @file_content = file_content
    end

    def copy_to_ftp(filename = "untitled.txt", encoding = "ISO-8859-1")
      ftp = Net::FTP.new(FTP_SERVER[:host], FTP_SERVER[:username], FTP_SERVER[:password])
      ftp.passive = true
      Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write @file_content
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

  end
end