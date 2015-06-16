# -*- encoding : utf-8 -*-
class Picture < ActiveRecord::Base
  belongs_to :product
  has_enumeration_for :display_on, :with => DisplayPictureOn
  mount_uploader :image, PictureUploader
  after_update :invalidate_cdn_image

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
