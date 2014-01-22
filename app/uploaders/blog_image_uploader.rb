# encoding: utf-8

class BlogImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Piet::CarrierWaveExtension
  storage :fog

  def store_dir
    "blog_images_for_home/"
  end  

  process :optimize

  version :old_home do
    process :resize_to_fit => [318, 205]
  end

  version :new_home do
    process :resize_to_fit => [490, 367]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
