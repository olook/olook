# -*- encoding : utf-8 -*-
class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::MiniMagick
  # To optimize jpg images using jpegoptm
  include Piet::CarrierWaveExtension

  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  def store_dir
    "#{self.model.class.name.underscore.pluralize}/#{self.model.product.model_number}/#{self.model.display_on}"
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

  process optimize: [{quality: 85}]

  version :thumb do
    process :resize_to_limit => [45, 68]
  end
  version :bag do
    process :resize_to_limit => [70, 70]
  end
  #adjustment thumb size picture on sacola page
  version :checkout, :from_version => :showroom do
    process :resize_to_fill => [45, 68]
  end
  #end
  version :catalog, from_version: :suggestion do
    process :resize_to_fill => [200, 300]
  end
  version :showroom do
    process :resize_to_limit => [146, 220]
  end
  version :suggestion do
    process :resize_to_limit => [146, 220]
  end
  version :main do
    process :resize_to_limit => [365, 550]
  end
  version :zoom_out do
    process :resize_to_limit => [730, 1100]
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "image-#{generate_token}.#{File.extname(original_filename)}" if original_filename.present?
  end

  private

    def generate_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(64/2))
    end
end
