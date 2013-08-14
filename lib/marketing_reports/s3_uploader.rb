# -*- encoding : utf-8 -*-
module MarketingReports
  class S3Uploader

    TEMP_PATH = "#{Rails.root}/tmp/"

    def initialize(source = "allin")
      connection = Fog::Storage.new provider: 'AWS'
      @fog_dir = connection.directories.get(Rails.env.production? ? "olook-ftp" : "olook-ftp-dev", prefix: source)
    end

    def copy_file(filename)
      file_content = File.open(TEMP_PATH+DateTime.now.strftime(filename))
      @fog_dir.files.create(key: filename, body: file_content, public: false)
    end
  end
end
