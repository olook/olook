class CatalogHeader::BigBannerCatalogHeader < CatalogHeader::CatalogHeader
  attr_accessible :big_banner, :link_big_banner, :alt_big_banner
  validates :big_banner, :link_big_banner, :alt_big_banner, presence: true

  mount_uploader :big_banner, CatalogHeaderUploader
end
