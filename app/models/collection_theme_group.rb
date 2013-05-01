class CollectionThemeGroup < ActiveRecord::Base
  validates :name, presence: true

  acts_as_list

  has_many :collection_themes, dependent: :nullify
end
