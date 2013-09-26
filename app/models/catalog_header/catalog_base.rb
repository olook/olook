class CatalogHeader::CatalogBase < ActiveRecord::Base
  attr_accessible :h1, :h2, :type, :url

  validates :type, :url, :presence => true, :exclusion => ["CatalogHeader::CatalogBase"]

  def self.factory params
   if params[:type] == 'BigBannerCatalogBase'
     BigBannerCatalogBase.new(params)
   elsif params[:type] == 'SmallBannerCatalogBase'
     SmallBannerCatalogBase.new(params)
   else
     TextCatalogBase.new(params)
   end
  end
end
