class Clipping < ActiveRecord::Base
  attr_accessible :clipping_text, :link, :logo, :published_at, :source, :title, :pdf_file, :alt
  mount_uploader :logo, ImageUploader
  mount_uploader :pdf_file, FileUploader

  validates :clipping_text, :link, :logo, :published_at, :source, :title, :pdf_file, presence: true

  default_scope { order('published_at desc') }
end
