class CatalogHeader::CatalogBase < ActiveRecord::Base
  attr_accessible :h1, :h2, :type, :url

  validates :type, :url, :presence => true, :exclusion => ["CatalogHeader::CatalogBase"]

  def self.factory params
   if params[:type] == 'BigBannerCatalogBase'
     CatalogHeader::BigBannerCatalogHeader.new(params)
   elsif params[:type] == 'SmallBannerCatalogBase'
     CatalogHeader::SmallBannerCatalogHeader.new(params)
   else
     CatalogHeader::TextCatalogHeader.new(params)
   end
  end
end
