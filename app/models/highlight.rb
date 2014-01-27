# -*- encoding : utf-8 -*-
class Highlight < ActiveRecord::Base
  after_save :clean_cache
  after_destroy :clean_cache

  mount_uploader :image, BannerUploader

  validates :image, presence: true
  validates :link, presence: true
  validates :position, presence: true
  validates :title, presence: true
  validates :subtitle, presence: true

  def self.highlights_to_show type
    Rails.cache.fetch("highlights-#{type}", :expires_in => 30.minutes) do 
      highlights = where(highlight_type: type).order(:position)
      highlights || []
    end
  end

  def self.grouped_by_type
    grouped_highlights = {}
    HighlightType.list.each do |type_id|
      grouped_highlights[type_id] = Highlight.where(highlight_type: type_id).order(:position)
    end    
    grouped_highlights
  end

  private
    def clean_cache
      HighlightType.list.each{|id| Rails.cache.delete("highlights-#{id}")}
    end

end
