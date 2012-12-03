# == Schema Information
#
# Table name: moments
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  active       :boolean          default(FALSE)
#  slug         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  header_image :string(255)
#  article      :string(25)       not null
#  position     :integer          default(1)
#

class Moment < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: true

  mount_uploader :header_image, ImageUploader
  
  has_one :catalog, class_name: "Catalog::Moment", foreign_key: "association_id"

  after_create :generate_catalog

  scope :active, where(active: true)
  
  private
  
  def generate_catalog
    self.build_catalog.save!
  end
end
