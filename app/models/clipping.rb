class Clipping < ActiveRecord::Base
  attr_accessible :clipping_text, :link, :logo, :published_at, :source, :title, :pdf_file, :alt
  mount_uploader :logo, ImageUploader
  mount_uploader :pdf_file, FileUploader

  validates :clipping_text, :logo, :published_at, :source, :title, presence: true
  validates_with ClippingValidator

  scope :latest, order('published_at desc')
end
