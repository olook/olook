class Catalog::Moment < Catalog::Catalog
  belongs_to :collection_theme, :class_name => "::CollectionTheme", :foreign_key => "association_id"
end
