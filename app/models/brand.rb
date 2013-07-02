class Brand < ActiveRecord::Base
  attr_accessible :header_image, :header_image_alt, :name
  validates :name, presence: true
  validates :header_image, presence: true
  mount_uploader :header_image, BannerUploader
  before_save :format_name

  private

    def format_name
      self.name = ActiveSupport::Inflector.transliterate(self.name).downcase.titleize
    end
end
