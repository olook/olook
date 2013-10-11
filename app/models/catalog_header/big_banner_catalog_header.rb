class CatalogHeader::BigBannerCatalogHeader < CatalogHeader::CatalogBase
  attr_accessible :big_banner, :link_big_banner, :alt_big_banner
  validates :big_banner, :link_big_banner, :alt_big_banner, presence: true

  mount_uploader :big_banner, CatalogHeaderUploader

  def big_banner?
    true
  end
end
