class FreebieVariant < ActiveRecord::Base

  belongs_to :variant
  belongs_to :freebie, :class_name => 'Variant'

  validates :variant_id, :freebie_id, :presence => true


end
