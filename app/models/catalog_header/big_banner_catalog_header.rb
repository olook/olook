class CatalogHeader::BigBannerCatalogHeader < CatalogHeader::CatalogHeader
  attr_accessible :big_banner, :link_big_banner, :alt_big_banner

  mount_uploader :big_banner, CatalogHeaderUploader
end
