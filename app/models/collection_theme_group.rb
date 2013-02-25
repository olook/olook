class CollectionThemeGroup < ActiveRecord::Base
  validates :name, presence: true

  acts_as_list

  has_many :collections_themes, class_name: "CollectionTheme"
end
