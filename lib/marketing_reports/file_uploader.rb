# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'
require 'yaml'

module MarketingReports
  class FileUploader

    TEMP_PATH = "#{Rails.root}/tmp/"
    CONFIG_DIR = "#{Rails.root}/config/"

    def initialize(filename = "untitled.txt", file_content)
      @filename = filename
      @file_content = file_content
      @encoding = "ISO-8859-1"
    end

    def save_to_disk(info_ftp = nil)
      self.save_local_file
      self.copy_file
      #self.upload_to_ftp(info_ftp) if info_ftp && self.is_production?
    end

    def save_local_file
     File.open(TEMP_PATH+@filename, 'w', :encoding => @encoding) do |file|
        file.write(@file_content)
      end
    end

    def copy_file
      report_path = self.is_production? ? '/home/allinmail' : Rails.rooT
      FileUtils.copy(TEMP_PATH+@filename, "#{report_path}/#{@filename}")
    end

    def upload_to_ftp(info_ftp)
      self.ftp_information(info_ftp)
      Net::FTP.open(@ftp_address) do |ftp|
        ftp.login(@username, @password)
        ftp.chdir(@path) unless @path.nil? || @path.strip.chomp == ""
        ftp.puttextfile(TEMP_PATH+@filename)
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

    def is_production?
      Rails.env.production?
    end

  end
end
