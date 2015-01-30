# encoding: utf-8

class HighlightBannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Piet::CarrierWaveExtension

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :side, if: :is_side? do
    process :resize_to_fit => [239, 360]
    process optimize: [{quality: 90}]
    version :thumb do
      process :resize_to_fit => [122, 90]
      process optimize: [{quality: 90}]
    end 
  end 


  version :central, if: :is_central? do
    process :resize_to_fit => [489, 361]
    process optimize: [{quality: 90}]
    version :thumb do
      process :resize_to_fit => [122, 90]
      process optimize: [{quality: 90}]
    end
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected

  def is_side? picture
    model.is_left_image? || model.is_right_image?
  end

  def is_central? picture
    model.is_center_image?
  end
end
