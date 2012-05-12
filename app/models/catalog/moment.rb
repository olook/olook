class Catalog::Moment < Catalog::Catalog
  belongs_to :moment, :class_name => "Moment", :foreign_key => "association_id"

end
