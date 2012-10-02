# -*- encoding : utf-8 -*-

require 'net/ftp'
require 'tempfile'
require 'fileutils'

module MarketingReports
  class FileUploader

    REPORT_PATH = Dir.exists?('/home/allinmail') ? '/home/allinmail' : '.'
    TEMP_PATH = '/tmp/'

    def initialize(file_content)
      @file_content = file_content
    end

    def save_to_disk(filename = "untitled.txt", encoding = "ISO-8859-1")
      Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write(@file_content)
        if File.exists?(file.path)
          FileUtils.copy(file.path, "#{REPORT_PATH}/#{filename}")
        else
          new_file = File.open("#{REPORT_PATH}/#{filename}", "w")
          new_file.write(@file_content)
          new_file.close
        end
      end
    end

  end
end