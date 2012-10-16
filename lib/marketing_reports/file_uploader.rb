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

    def save_to_disk(filename = "untitled.txt", info_ftp = nil, encoding = "ISO-8859-1"  )
      self.save_local_file(filename, encoding)
      self.upload_to_ftp(filename, info_ftp) if info_ftp
    end

    def save_local_file(filename, encoding)
     Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}") if File.exists?(file.path)

        new_file = File.open("backup_#{filename}", "w")
        new_file.write(@file_content)
        new_file.close
      end
    end

    def upload_to_ftp(filename, info_ftp)
      self.ftp_information(info_ftp)
      Net::FTP.open(@ftp_address) do |ftp|
        ftp.login(@username, @password)
        ftp.chdir(@path) unless @path.nil? || @path.strip.chomp == ""
        ftp.puttextfile(filename)
        ftp.close
      end
    end

    def ftp_information(info_ftp)
      config = YAML::load(File.open(info_ftp))
      @ftp_address = config["ftp"]["address"]
      @username = config["ftp"]["user"]
      @password = config["ftp"]["password"]
      @path = config["ftp"]["path"]
    end
  end
end
