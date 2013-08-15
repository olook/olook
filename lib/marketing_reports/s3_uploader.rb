# -*- encoding : utf-8 -*-
module MarketingReports
  class S3Uploader

    TEMP_PATH = "#{Rails.root}/tmp/"

    def initialize(folder = "allin")
      connection = Fog::Storage.new provider: 'AWS'
      @folder = folder
      @fog_dir = connection.directories.get(Rails.env.production? ? "olook-ftp" : "olook-ftp-dev")
    end

    def copy_file(filename)
      file_content = File.open(TEMP_PATH+DateTime.now.strftime(filename))
      @fog_dir.files.create(key: "#{@folder}/#{filename}", body: file_content, public: false)
    end
  end
end
