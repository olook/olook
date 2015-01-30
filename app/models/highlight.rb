# -*- encoding : utf-8 -*-
class Highlight < ActiveRecord::Base
  extend EnumerateIt

  mount_uploader :image, CentralHighlightBannerUploader
  mount_uploader :left_image, SideHighlightBannerUploader
  mount_uploader :right_image, SideHighlightBannerUploader
  mount_uploader :banner_image, HighlightBannerUploader

  has_enumeration_for :position, with: HighlightPosition, required: true

  after_save :clean_cache
  after_destroy :clean_cache

  validates :link, presence: true
  validates :position, presence: true
  validates :title, presence: true
  validates :subtitle, presence: true
  validates :alt_text, presence: true
  validates :image, presence: true

  def self.highlights_to_show
    Rails.cache.fetch("highlights", :expires_in => 30.minutes) do
      highlights = {}
      for i in 1..3 
        highlights[i] = where(position: i).last
      end
      highlights
    end
  end

  def banner_image_for_position size= :site
    case position
    when HighlightPosition::CENTER 
      img = banner_image.central
      img = img.thumb if size == :thumb
      img.url
    when HighlightPosition::LEFT
      img = banner_image.side
      img = img.thumb if size == :thumb
      img.url
    when HighlightPosition::RIGHT
      img = banner_image.side
      img = img.thumb if size == :thumb
      img.url
    end
  end

  def image_for_position size= :site
    case position
    when HighlightPosition::CENTER 
      image.url(size)
    when HighlightPosition::LEFT
      left_image.url(size)
    when HighlightPosition::RIGHT
      right_image.url(size)
    end
  end

  def is_center_image?
    position == HighlightPosition::CENTER
  end

  def is_left_image?
    position == HighlightPosition::LEFT
  end

  def is_right_image?
    position == HighlightPosition::RIGHT
  end

  private

  def clean_cache
    Rails.cache.delete("highlights")
  end
end
