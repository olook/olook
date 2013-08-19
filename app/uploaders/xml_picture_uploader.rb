# -*- encoding : utf-8 -*-
class XmlPictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # Include RMagick or ImageScience support:
  # include CarrierWave::ImageScience

  # To optimize jpg images using jpegoptm
  include Piet::CarrierWaveExtension

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  def store_dir
    "#{self.model.class.name.underscore.pluralize}/#{self.model.model_number}"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   root_dir = Rails.env.test? ? 'uploads/test/' : 'uploads/'
  #   "#{root_dir}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process :optimize

  version :main do
    process resize_to_fill: [1000, 1000]
  end

  version :thumb do
    process resize_to_fill: [300, 300]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

