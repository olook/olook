class Clipping < ActiveRecord::Base
  attr_accessible :clipping_text, :link, :logo, :published_at, :source, :title
  mount_uploader :logo, ImageUploader

  validates :clipping_text, :link, :logo, :published_at, :source, :title, presence: true

  default_scope { order('published_at desc') }
end
