# == Schema Information
#
# Table name: catalogs
#
#  id             :integer          not null, primary key
#  type           :string(255)
#  association_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Catalog::Moment < Catalog::Catalog
  belongs_to :moment, :class_name => "::Moment", :foreign_key => "association_id"
end
