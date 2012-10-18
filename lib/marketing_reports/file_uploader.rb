# -*- encoding : utf-8 -*-

require 'fileutils'
require 'yaml'

module MarketingReports
  class FileUploader

    TEMP_PATH = "#{Rails.root}/tmp/"

    def initialize(filename = "untitled.txt", file_content)
      @filename = filename
      @file_content = file_content
      @encoding = "UTF-8"
    end

    def save_to_disk
      self.save_local_file
      self.copy_file
    end

    def save_local_file
     File.open(TEMP_PATH+@filename, 'w', :encoding => @encoding) do |file|
        file.write(@file_content)
      end
    end

    def copy_file
      report_path = Rails.env.production? ? '/home/allinmail' : Rails.root
      FileUtils.copy(TEMP_PATH+@filename, "#{report_path}/#{@filename}")
    end
  end
end
