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
      return unless Setting.upload_marketing_files_to_s3
      file_content = File.open(TEMP_PATH+DateTime.now.strftime(filename))
      updload(filename, file_content)
    end

    def upload(filename, file_content, is_public=false)
      @fog_dir.files.create(key: "#{@folder}/#{filename}", body: file_content, public: is_public)
      "https://s3.amazonaws.com/#{@fog_dir.key}/#{@folder}/#{filename}"
    end
  end
end
