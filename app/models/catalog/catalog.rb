class Catalog::Catalog < ActiveRecord::Base
  validates :type, :presence => true, :exclusion => ["Catalog::Catalog"]
end
