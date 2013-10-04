# encoding: utf-8
class CatalogHeaderUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # To optimize jpg images using jpegoptm
  include Piet::CarrierWaveExtension

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process optimize: [{quality: 85}]

  version :big do
    process :resize_to_fit => [600, 500]
  end

  version :medium do
    process :resize_to_fit => [300, 600]
  end

  version :small do
    process :resize_to_fit => [150, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end

