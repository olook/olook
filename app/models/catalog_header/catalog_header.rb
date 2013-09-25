class CatalogHeader::CatalogHeader < ActiveRecord::Base
  attr_accessible :h1, :h2, :type, :url

  validates :type, :presence => true, :exclusion => ["CatalogHeader::CatalogHeader"]
end
