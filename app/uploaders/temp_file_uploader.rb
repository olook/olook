# -*- encoding : utf-8 -*-
class TempFileUploader < CarrierWave::Uploader::Base
  storage :fog
  
  def filename
    @name ||= "#{SecureRandom.uuid}.#{file.extension}" if original_filename.present?
  end
end
