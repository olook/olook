class CatalogHeader::CustomUrlCatalogHeader < CatalogHeader::CatalogBase
  attr_accessible :url, :organic_url, :product_list, :custom_url, :big_banner, :link_big_banner, :alt_big_banner
  validates :url, :organic_url, :product_list, :big_banner, :link_big_banner, :alt_big_banner, presence: true
end
