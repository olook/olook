# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'

module MarketingReports
  class FileUploader

    REPORT_PATH = '/home/allinmail'
    TEMP_PATH = '/tmp/'

    def initialize(file_content)
      @file_content = file_content
    end

    def save_to_disk(filename = "untitled.txt", encoding = "ISO-8859-1")
      Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}") if File.exists?(file.path)
      end
    end

  end
end