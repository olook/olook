# -*- encoding : utf-8 -*-

require 'fileutils'
require 'yaml'

module MarketingReports
  class FileUploader

    TEMP_PATH = "#{Rails.root}/tmp/"

    def initialize(filename = "untitled.txt", file_content)
      @filename = filename
      @file_content = file_content
      @encoding = "ISO-8859-1" #"UTF-8"
    end

    def save_local_file(adapt_encoding = true)
      file_path = TEMP_PATH+DateTime.now.strftime(@filename)
      File.open(file_path, 'w', :encoding => @encoding) do |file|
        file.write(@file_content) #.encode(@encoding).force_encoding(@encoding))
      end
      # Nasty workaround to solve the encoding issue
      `iconv -c --from-code=utf-8 --to-code=#{@encoding}//IGNORE #{file_path} > #{file_path}.iso;mv #{file_path}.iso #{file_path}` if adapt_encoding
    end

    def self.copy_file(filename)
      report_path = Rails.env.production? ? '/home/allinmail' : Rails.root
      FileUtils.copy(TEMP_PATH+DateTime.now.strftime(filename), "#{report_path}/#{DateTime.now.strftime(filename)}")
    end
  end
end
