class Highlight < ActiveRecord::Base
  after_save :clean_cache
  after_destroy :clean_cache

  mount_uploader :image, BannerUploader

  validates :image, presence: true
  validates :link, presence: true
  validates :position, presence: true

  def self.highlights_to_show
    Rails.cache.fetch("highlights", :expires_in => 15.minutes) do 
      all(order: :position)
    end
  end

  private
    def clean_cache
      Rails.cache.delete("highlights")
    end

end
