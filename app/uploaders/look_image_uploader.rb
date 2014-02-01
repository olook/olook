# encoding: utf-8

class LookImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Piet::CarrierWaveExtension

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :showroom do
    process :resize_to_fit => [242, 365]
    process :optimize
  end

  version :big_showroom do
    process :resize_to_fit => [294, 443]
    process :optimize
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
