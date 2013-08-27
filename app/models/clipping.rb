class Clipping < ActiveRecord::Base
  attr_accessible :clipping_text, :link, :logo, :published_at, :source, :title
  mount_uploader :logo, ImageUploader
end
