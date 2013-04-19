# -*- encoding : utf-8 -*-
require 'file_size_validator'
class Picture < ActiveRecord::Base
  belongs_to :product
  validates :product, :image, :presence => true
  has_enumeration_for :display_on, :with => DisplayPictureOn, :required => true
  mount_uploader :image, PictureUploader
  after_update :invalidate_cdn_image

  validates :image,
    :presence => true,
    :file_size => {
      :maximum => 0.09.megabytes.to_i
    }

  def self.sort_positions!(ids)
    ids.each_with_index do |id, index|
      update_all({ position: index + 1 }, { id: id })
    end
  end

  private
  def invalidate_cdn_image
    CloudfrontInvalidator.new.invalidate(self.image.url.slice(23..150)) unless self.image.url.nil?
  end
end
