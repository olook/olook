# -*- encoding : utf-8 -*-
class TempFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  process :strip

  def filename
    @name ||= "#{SecureRandom.uuid}.#{file.extension}" if original_filename.present?
  end
end
