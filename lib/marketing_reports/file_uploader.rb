# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'

module MarketingReports
  class FileUploader

    REPORT_PATH = Rails.env.production? ? '/home/allinmail' : Rails.root
    TEMP_PATH = '/tmp/'

    def initialize(file_content)
      @file_content = file_content
    end

    def save_to_disk(filename = "untitled.txt", encoding = "ISO-8859-1")
      Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}") if File.exists?(file.path)
        
        new_file = File.open("backup_#{filename}", "w")
        new_file.write(@file_content)
        new_file.close
      end
    end

  end
end