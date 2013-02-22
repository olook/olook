class CollectionThemeGroup < ActiveRecord::Base
  acts_as_list

  validates :name, presence: true
end
