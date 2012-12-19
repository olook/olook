class FreebieVariant < ActiveRecord::Base

  belongs_to :variant
  belongs_to :freebie, :class_name => 'Variant'
  
  validates :variant_id, :freebie_id, :presence => true
  validate :not_a_shoe, :if => :freebie

  # delegate :model_number, :to => :freebie
  # delegate :name, :to => :freebie
  # delegate :model_number, :to => :freebie

  def not_a_shoe
    if freebie.product.category == Category::SHOE
      errors.add(:freebie, "O brinde nao pode ser sapato")
    end
  end


end
