# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'
require 'yaml'

module MarketingReports
  class FileUploader

    REPORT_PATH = Rails.env.production? ? '/home/allinmail' : Rails.root
    TEMP_PATH = "#{Rails.root}/tmp/"
    CONFIG_DIR = "#{Rails.root}/config/"

    def initialize(file_content)
      @file_content = file_content
    end

    def save_to_disk(filename = "untitled.txt", info_ftp = nil, encoding = "UTF-8"  )
      self.save_local_file(filename, encoding)
      self.upload_to_ftp(filename, info_ftp) if info_ftp
    end

    def save_local_file(filename, encoding)
     File.open(TEMP_PATH+filename, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}") if File.exists?(file.path)
      end
    end

    def upload_to_ftp(filename, info_ftp)
      self.ftp_information(info_ftp)
      Net::FTP.open(@ftp_address) do |ftp|
        ftp.login(@username, @password)
        ftp.chdir(@path) unless @path.nil? || @path.strip.chomp == ""
        ftp.puttextfile("#{TEMP_PATH}/#{filename}")
        ftp.close
      end
    end

    def ftp_information(info_ftp)
      config = YAML::load(File.open(CONFIG_DIR+info_ftp))
      @ftp_address = config["ftp"]["address"]
      @username = config["ftp"]["user"]
      @password = config["ftp"]["password"]
      @path = config["ftp"]["path"]
    end
  end
end
