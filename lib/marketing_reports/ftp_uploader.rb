require 'net/ftp'
require 'tempfile'
require 'fileutils'
require 'yaml'

module MarketingReports
  class FtpUploader

    CONFIG_DIR = "#{Rails.root}/config/"
    TEMP_PATH = "#{Rails.root}/tmp/"

    def initialize(filename, info_ftp)
      @info_ftp = info_ftp
      @filename = filename
    end

    def upload_to_ftp
      self.ftp_information(@info_ftp)
      Net::FTP.open(@ftp_address) do |ftp|
        ftp.passive = true
        ftp.login(@username, @password)
        ftp.chdir(@path) unless @path.nil? || @path.strip.chomp == ""
        ftp.puttextfile(TEMP_PATH+DateTime.now.strftime(@filename))
        ftp.close
      end
    end

    def ftp_information(info_ftp)
      config = YAML::load(File.open(CONFIG_DIR+@info_ftp))
      @ftp_address = config["ftp"]["address"]
      @username = config["ftp"]["user"]
      @password = config["ftp"]["password"]
      @path = config["ftp"]["path"]
    end
  end
end
