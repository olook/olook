# -*- encoding : utf-8 -*-
class Picture < ActiveRecord::Base
  belongs_to :product
  validates :product, :presence => true
  has_enumeration_for :display_on, :with => DisplayPictureOn, :required => true
  mount_uploader :image, PictureUploader
  after_update :invalidate_cdn_image
  before_save :set_position

  private
  def invalidate_cdn_image
    CloudfrontInvalidator.new.invalidate(self.image.url.slice(23..150)) unless self.image.url.nil?
  end

  protected
  def set_position
    self.position ||= 1 + (Picture.where(product_id: product_id).maximum(:position) || 0)
  end
end
