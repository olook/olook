# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'
require 'yaml'

module MarketingReports
  class FileUploader

    REPORT_PATH = Rails.env.production? ? '/home/allinmail' : Rails.root
    TEMP_PATH = '/tmp/'

    def initialize(file_content)
      @file_content = file_content
    end

    def save_to_disk(filename = "untitled.txt", encoding = "ISO-8859-1", info_ftp )
      if info_file
        self.upload_to_ftp(filename, encoding, info_ftp)
      else
        self.save_local_file(filename, encoding)
      end
    end

    #private

    def save_local_file(filename, enconding)
     Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}") if File.exists?(file.path)

        new_file = File.open("backup_#{filename}", "w")
        new_file.write(@file_content)
        new_file.close
      end
    puts "save local"
    end

    def upload_to_ftp(filename, enconding, info_ftp)
      self.ftp_information(info_ftp)
      Net::FTP.open(@ftp_address) do |ftp|
        ftp.login(@username, @password)
        ftp.puttextfile(@file)
        ftp.close
      end
    end

    def ftp_information(info_file)
      config = YAML::load(File.open(info_file))
      @ftp_address = config["in_cart"]["ftp"]["address"]
      @username = config["in_cart"]["ftp"]["user"]
      @password = config["in_cart"]["ftp"]["password"]
    end
  end
end
