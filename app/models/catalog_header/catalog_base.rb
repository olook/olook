class CatalogHeader::CatalogBase < ActiveRecord::Base
  attr_accessible :seo_text, :type, :url, :enabled

  validates :type, :url, :presence => true, :exclusion => ["CatalogHeader::CatalogBase"]

  scope :with_type, ->(type) {where(type: type)} 

  def self.factory params
    if params[:type] == 'CatalogHeader::BigBannerCatalogHeader'
      CatalogHeader::BigBannerCatalogHeader.new(params)
    elsif params[:type] == 'CatalogHeader::SmallBannerCatalogHeader'
      CatalogHeader::SmallBannerCatalogHeader.new(params)
    else
      CatalogHeader::TextCatalogHeader.new(params)
    end
  end

  def self.for_url(url)
    where(enabled:true, url: url)
  end

  def text?
    false
  end

  def big_banner?
    false
  end

  def small_banner?
    false
  end
end
