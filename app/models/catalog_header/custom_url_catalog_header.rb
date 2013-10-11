class CatalogHeader::CustomUrlCatalogHeader < CatalogHeader::CatalogBase
  attr_accessible :organic_url, :product_list, :custom_url, :big_banner, :link_big_banner, :alt_big_banner
  validates :organic_url, :product_list, :custom_url, :big_banner, :link_big_banner, :alt_big_banner, presence: true
end
