class CatalogHeader::CustomUrlCatalogHeader < CatalogHeader::CatalogBase
  attr_accessible :organic_url, :product_list, :custom_url, :big_banner, :link_big_banner, :alt_big_banner,
                  :resume_title, :text_complement, :title,
                  :medium_banner, :link_medium_banner,:alt_medium_banner,
                  :small_banner1, :link_small_banner1,:alt_small_banner1,
                  :small_banner2, :link_small_banner2,:alt_small_banner2

  validates :organic_url, :product_list
end
