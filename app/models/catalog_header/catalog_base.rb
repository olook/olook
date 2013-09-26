class CatalogHeader::CatalogBase < ActiveRecord::Base
  attr_accessible :h1, :h2, :type, :url

  validates :type, :url, :presence => true, :exclusion => ["CatalogHeader::CatalogBase"]

  def factory params
    
  end
end
