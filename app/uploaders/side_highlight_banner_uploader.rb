# encoding: utf-8

class SideHighlightBannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Piet::CarrierWaveExtension

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :site do
    process :resize_to_fit => [239, 360]
    process optimize: [{quality: 90}]
  end 

  version :thumb do
    process :resize_to_fit => [122, 90]
    process optimize: [{quality: 90}]
  end 

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
